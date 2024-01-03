<?php
use Restserver\Libraries\REST_Controller;

defined( 'BASEPATH' ) OR exit( 'No direct script access allowed' );
require APPPATH . 'libraries/REST_Controller.php';

require APPPATH . 'libraries/Format.php';
require_once( APPPATH . 'services/ApiService.php' );

class API extends REST_Controller
 {
    public $apiService;

    public function __construct()
 {
        parent::__construct();
        date_default_timezone_set( 'Asia/Manila' );
        $this->apiService = new ApiService();
        $this->load->model( 'Model_repo', 'model' );
    }

    public function index_post() {
        $this->response( [
            'messege0'=>'FORBIDDEN',

        ], Rest_Controller::HTTP_FORBIDDEN );
    }

    public function index_get() {
        echo phpinfo();
        // $this->response( [
        //     'messege0'=>'FORBIDDEN',

        // ], Rest_Controller::HTTP_FORBIDDEN );
    }

    private function call_external_api( $data, $get_header )
 {
        // RE-WRITE $DATA FOR TESTING PURPOSES
        $response = $this->apiService->call_external_api( $data, $get_header );
        return $response;
    }

    public function all_transaction_data_get()
    {
        header("Access-Control-Allow-Origin: *");
        header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
        header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

     $data=  $this->model->transaction_data();
  
      $this->response( [
        'messege0'=>'Success',
        'status'=>'true',
        'data'=>$data
    ], Rest_Controller::HTTP_UNAUTHORIZED );


    }

   

  
}
