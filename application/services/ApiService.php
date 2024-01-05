<?php
defined('BASEPATH') or exit('No direct script access allowed');

class ApiService
{

    protected $CI;

    protected $secret_key;

    protected $endpoint_base_url;

    public function __construct()
    {
        $this->CI = &get_instance();
        $this->CI->load->database();

        // Key for encryption ( must be the same on both ends )
        // $this->secret_key = $_ENV[ 'SECRET_KEY' ];
        $this->endpoint_base_url = $_ENV['ENDPOINT_BASE_URL'];
    }

    // Generation of Token were developed here as well to lessen the steps
    // This will ommit the step of getting token from the External API
    // private function generate_token()
    // {
    // $subject = 'External Call From NGSI LT Core Front-End';
    // $date_created = time();

    // $expiration_date = strtotime( '+1 hour' );

    // $data = [
    // 'subject' => $subject,
    // 'date_created' => $date_created,
    // 'expiration_date' => $expiration_date,
    // ];

    // $iv = openssl_random_pseudo_bytes( openssl_cipher_iv_length( 'aes-256-cbc' ) );
    // $dataToEncrypt = json_encode( $data );
    // $encryptedMessage = openssl_encrypt( $dataToEncrypt, 'aes-256-cbc', $this->secret_key, 0, $iv );
    // return base64_encode( $iv . $encryptedMessage );
    // }
    public function call_external_api($data, $generateToken)
    {
        $endpoint = $this->endpoint_base_url . '/pgw/api/v1/transactions/qr-codes/generate/';

        $dataToSend = $data;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $endpoint);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization:' . $generateToken,
            'Content-Type: application/json'
        ]);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($dataToSend, JSON_PRESERVE_ZERO_FRACTION));

        $response = curl_exec($ch);
        $http_status_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        // if ( curl_errno( $ch ) ) {
        // $error = curl_error( $ch );

        // http_response_code( 500 );

        // return [
        // 'status_code' => 500,
        // 'error' => $error
        // ];
        // }
        curl_close($ch);

        // expecting to be a json encoded response
        $resp['response'] = $response;
        $resp['status_code'] = $http_status_code;

        return $resp;
    }

    public function call_back($data, $endpoint)
    {
        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_URL => $endpoint,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => json_encode($data),
            CURLOPT_HTTPHEADER => array(
                'Content-Type: application/json'
            )
        ));

        $response = curl_exec($curl);
        $http_status_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        curl_close($curl);

        $resp['response'] = $response;
        $resp['status_code'] = $http_status_code;

        return $resp;
    }
}
