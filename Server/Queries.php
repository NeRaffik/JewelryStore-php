<?php
spl_autoload_register(function ($class) { include 'Server/PdoConnect.php'; });

class Queries{

    private static $PDO;

    public static function productsInfo() {
        return "SELECT FinishedProducts.Id, 
        FinishedProducts.ProductName, 
        FinishedProducts.ProductPrice, 
        FinishedProducts.Discount, 
        Images.ImagePath, 
        Images.Format
        FROM FinishedProducts LEFT OUTER JOIN
            Conformity_ImagesToFProduct ON FinishedProducts.Id = Conformity_ImagesToFProduct.IdProduct LEFT OUTER JOIN
            Images ON Conformity_ImagesToFProduct.IdImage = Images.Id
        ORDER BY FinishedProducts.ProductName";
    }

    public static function getInfo($querie) { //без заполнителей
        try {
            self::$PDO = PdoConnect::getInstance();
            $result = self::$PDO->PDO->query($querie);
            self::$PDO = null;
        }
        catch (PDOException $e) {
            echo $e->getMessage();
        }

        return $result;

    }

}

?>