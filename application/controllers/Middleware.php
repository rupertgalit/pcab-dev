<?php
use Restserver\Libraries\REST_Controller;

defined('BASEPATH') or exit('No direct script access allowed');
require APPPATH . 'libraries/REST_Controller.php';

require APPPATH . 'libraries/Format.php';
require_once (APPPATH . 'services/ApiService.php');

class Middleware extends REST_Controller
{

    public $apiService;

    public function __construct()
    {
        parent::__construct();
        date_default_timezone_set('Asia/Manila');
        $this->apiService = new ApiService();
        $this->load->model('Model_repo', 'model');
    }

    public function index_post()
    {
        $this->response([
            'messege0' => 'FORBIDDEN'
        ], Rest_Controller::HTTP_FORBIDDEN);
    }

    public function index_get()
    {
        $this->response([
            'messege0' => 'FORBIDDEN'
        ], Rest_Controller::HTTP_FORBIDDEN);
    }

    private function call_external_api($data, $get_header)
    {
        // RE-WRITE $DATA FOR TESTING PURPOSES
        $response = $this->apiService->call_external_api($data, $get_header);
        return $response;
    }

    public function generate_qr_post()
    {
        $this->output->set_content_type('application/json');

        $header = apache_request_headers();

        $data['data'] = json_decode(file_get_contents('php://input'), true);

        $transaction['endpoint'] = $data['data']['endpoint'];
        $transaction['reference_number'] = $data['data']['reference_number'];

        $validate_ref = $this->model->select_refNumber($transaction['reference_number']);
        if ($validate_ref) {
            $this->response([
                'messege' => 'Failed',
                'error0' => 'already ' . $validate_ref['status']
            ], Rest_Controller::HTTP_UNAUTHORIZED);
        }

        $txnAmount = $data['data']['merchant_details']['txn_amount'];

        $transaction['method'] = $data['data']['merchant_details']['method'];

        $transaction['txn_type'] = $data['data']['merchant_details']['txn_type'];

        $transaction['mobile_number'] = $data['data']['merchant_details']['scanner_mobile_number'];

        // $transaction[ 'city' ] = $data[ 'data' ][ 'merchant_details' ][ 'city' ];

        $transaction['txn_amount'] = $txnAmount;
        $transaction['date_created'] = date('Y-m-d H:i:s');
        $transaction['status'] = 'STARTED';

        $totalAmount = 0;

        foreach ($data['data']['other_details'] as $item) {

            $itemName = $item['item'];
            $amount = $item['amount'];
            // Sanitize and validate column name ( replace non-alphanumeric characters )
            $columnName = preg_replace('/[^a-zA-Z0-9_]/', '', $itemName);

            $transaction[$columnName] = $amount;

            // $totalAmount += $amount;
        }

        // if ($txnAmount != $totalAmount) {

        //     $this->response([

        //         'error' => 'True',
        //         'messege' => 'the txn_amount in not equal of total other_details amount'
        //     ], Rest_Controller::HTTP_UNAUTHORIZED);
        // }

        $get_header = $header['Authorization'];

        $params = json_encode($data['data']);

        $ins_data['params'] = $params;

        $ins_data['request_at'] = date('Y-m-d H:i:s');

        $ins_data['method'] = $_SERVER['REQUEST_METHOD'];

        $get_id = $this->model->insertApiLogs($ins_data);

        if ($get_id) {
            $transaction['callback_uri'] = $data['data']['callback_uri'];

            $get_transaction_id = $this->model->transaction_log($transaction);

            if (isset($data['data']['callback_uri'])) {
                unset($data['data']['callback_uri']);
            }

            if (isset($data['data']['other_details'])) {
                unset($data['data']['other_details']);
            }

            $data['data']['callback_uri'] = base_url() . 'middleware/postback/?ref=' . $data['data']['reference_number'];

            $response = $this->call_external_api($data['data'], $get_header);

            $update['response_at'] = date('Y-m-d H:i:s');

            $update['status'] = $response['status_code'];

            $update['api_response'] = $response['response'] . $data['data']['callback_uri'];

            $doUpdateApiLog = $this->model->doUpdateApilogs($update, $get_id);

            if ($doUpdateApiLog) {
                echo json_encode($data['data']['callback_uri']);
                echo $response['response'] . json_encode($totalAmount);
            }
        }
    }

    public function postback_post($ref_number = 0)
    {
        $ref_number = $_GET['ref'];

        $this->output->set_content_type('application/json');

        $data = json_decode(file_get_contents('php://input'), true);

        $data_exist = $this->model->finddata($ref_number);

        $call_back_data['reference_number'] = $ref_number;

        $call_back_data['callback_data'] = json_encode($data);

        $call_back_data['tbl_date'] = date('Y-m-d H:i:s');

        $call_back_data['TxId'] = $data['TxId'];

        $call_back_data['referenceNumber'] = $data['referenceNumber'];

        $call_back_data['callback_status'] = $data['status'];

        if ($data_exist != false) {

            $this->model->doInsertCallback($call_back_data);
            $this->response([
                'messege' => 'Failed',
                'error0' => 'already transact'
            ], Rest_Controller::HTTP_UNAUTHORIZED);
        } else {

            // / insert data to tbl_callback
            $do_cback_data = $this->model->doInsertCallback($call_back_data);

            if ($do_cback_data) {
                $TransData = $this->model->select_refNumber($ref_number);
                // this client response
                $response = $this->apiService->call_back($data, $TransData['callback_uri']);
                $transData['status'] = $this->status_get($data['status']);
                $transData['TxId'] = $call_back_data['TxId'];
                $transData['referenceNumber'] = $call_back_data['referenceNumber'];

                $transData['last_modified'] = date('Y-m-d H:i:s');
                $trans_updated = $this->model->updateTransaction($transData, $ref_number);

                if ($trans_updated) {

                    $cback_update['client_data_resp'] = json_encode($response);
                    $doUpdateApiLog = $this->model->updateCallBack($cback_update, $do_cback_data);

                    if ($response['status_code'] == 200 || $response['status_code'] == 201) {

                        $this->response([
                            'messege0' => 'Success',
                            'error' => 'false',
                            'data' => $doUpdateApiLog
                        ], Rest_Controller::HTTP_OK);
                    } else {
                        $this->response([
                            'messege0' => 'Success',
                            'error' => 'true',
                            'data' => $doUpdateApiLog
                        ], Rest_Controller::HTTP_OK);
                    }
                }
            }
        }
    }

    function status_get($type)
    {
        $caffeine = '';
        $map = [
            '1' => 'STARTED ',
            '2' => 'PENDING',
            '3' => 'FAILED',
            '4' => 'SUCCESS'
        ];

        $caffeine = $map[$type];
        return $caffeine;
    }

    public function samplecallback_post()
    {
        $this->response([
            'messege0' => 'Success',
            'error0' => 'false'
        ], Rest_Controller::HTTP_OK);
    }
}
