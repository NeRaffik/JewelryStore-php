<?php

class PdoConnect {

	private const SERVER = "Z";
	private const DB = "JEWELRY";
	private const USER = "Admin";
	private const PASS = "Admin";

    protected static $_instance;

	protected $DSN;
	protected $OPD;
	public $PDO;

    private function __construct() {
		
		$this->DSN = "sqlsrv:Server=" . self::SERVER . ";Database=" . self::DB;

		$this->OPD = array(
			PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, 
            //Установка способа обработки ошибок
			PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, 
            //Задаёт тип получаемого результата по-умолчанию
			PDO::ATTR_EMULATE_PREPARES => false, 
            //Эмуляция подготовленных запросов
            //PDO::SQLSRV_ATTR_DIRECT_QUERY => true
		);

		try {
			$this->PDO = new PDO($this->DSN, self::USER, self::PASS, $this->OPD);
			//$conn = new PDO("sqlsrv:Server=Z;Database=JEWELRY","Admin", "Admin");
		}
	 	catch (PDOException $e) {
	    	echo $e->getMessage();
		}
	}

    public static function getInstance() {

		if (self::$_instance === null)
			self::$_instance = new self;

		return self::$_instance;
	}

};

?>