<?php
spl_autoload_register(function ($class) { include 'Server/PdoConnect.php'; });

class Queries{

    private static $PDO;

    public static function productsInfo() {
        return "SELECT FinishedProducts.Id, 
        FinishedProducts.ProductName, 
        FinishedProducts.ProductPrice, 
        ISNULL(FinishedProducts.Discount, 0) AS Discount, 
        Images.ImagePath,
        FinishedProducts.ProductWeight, 
        Images.Format
        FROM FinishedProducts LEFT OUTER JOIN
            Conformity_ImagesToFProduct ON FinishedProducts.Id = Conformity_ImagesToFProduct.IdProduct LEFT OUTER JOIN
            Images ON Conformity_ImagesToFProduct.IdImage = Images.Id
        ORDER BY FinishedProducts.ProductName";
    }

    public static function currentProductInfo($productId) {
        return "DECLARE @productId INT
        SET @productId = 1;
        
        SELECT Images.ImagePath
        FROM Images INNER JOIN
              FinishedProducts ON Images.Id = FinishedProducts.Id
        WHERE (FinishedProducts.Id = @productId);
        
        SELECT Conformity_SizesToProductType.Size
        FROM Conformity_SizesToProductType INNER JOIN
              FinishedProducts ON Conformity_SizesToProductType.IdProductType = FinishedProducts.ProductType
        WHERE (FinishedProducts.Id = @productId);
        
        SELECT Insertions.Insertion, Insertions.Characteristic, Conformity_InsertionsToFProduct.Quantity
        FROM FinishedProducts INNER JOIN
              Conformity_InsertionsToFProduct ON FinishedProducts.Id = Conformity_InsertionsToFProduct.IdProduct INNER JOIN
              Insertions ON Conformity_InsertionsToFProduct.IdMaterial = Insertions.Id
        WHERE (FinishedProducts.Id = @productId);
        
        SELECT Materials.Material, Materials.MaterialSample
        FROM FinishedProducts INNER JOIN
              Conformity_MaterialsToFProduct ON FinishedProducts.Id = Conformity_MaterialsToFProduct.IdProduct INNER JOIN
              Materials ON Conformity_MaterialsToFProduct.IdMaterial = Materials.Id
        WHERE (FinishedProducts.Id = @productId);";
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