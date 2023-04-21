USE JEWELRY;

go

BEGIN TRANSACTION;

-- TABLE Materials ---------------------------------------------------
CREATE TABLE Materials
(
	Id INT IDENTITY PRIMARY KEY,
	Material NVARCHAR(250)  NOT NULL,
	MaterialSample SMALLINT, 

	CHECK(MaterialSample >0 AND MaterialSample < 1000)
);

INSERT INTO Materials 
VALUES
	('Золото', 375),
	('Золото', 500),
	('Золото', 583),
	('Золото', 585),
	('Золото', 750),
	('Золото', 958),
	('Золото', 999),
	('Серебро', 800),
	('Серебро', 830),
	('Серебро', 875),
	('Серебро', 925),
	('Серебро', 960),
	('Серебро', 999),
	('Платина', 950),
	('Платина', 850),
	('Платина', 900),
	('Палладий', 500),
	('Палладий', 850),
	('Родий', null),
	('Осмий', null),
	('Рутений', null),
	('Иридий', null); 

-- TABLE Insertions ---------------------------------------------------
CREATE TABLE Insertions
(
    Id INT IDENTITY PRIMARY KEY,
    Insertion NVARCHAR(250) NOT NULL,
    Characteristic NVARCHAR(250)
);

INSERT INTO Insertions 
VALUES
	('Дымчатый кварц', null),
	('Зеленый кварц', null),
	('Нефрит', null),
	('Сапфир с александритовым эффектом', '(H) Кр. Г 3/3Б.хор. 1-0.25кар'),
	('Турмалин', null),
	('Рубин', '(F) Ов. Г/1 1- 5.75кар'),
	('Жемчуг', 'культивированный, пресноводный'),
	('Жемчуг', 'природный морской'),
	('Бриллиант', '(НТНР) Кр 57А 3/3-1-0.25кар'),
	('Бриллиант', 'Кр 57B 1/3-1-0.5кар'),
	('Сапфир', '(H) Кр. Г 3/3Б.хор. 1-0.25кар'),
	('Изумруд', '(O) И-41 2/Г2 хор. 1-0.50кар'),
	('Сапфир желтый', '(U)'),
	('Танзанит', '(Н)'),
	('Янтарь', null),
	('Марказит', null),
	('Кубический цирконий', null),
	('Аквамарин', null),
	('Морганит', '(O) И-41 2/Г2 хор. 1-0.50кар'),
	('Родолит', null);

-- TABLE ProductTypes ---------------------------------------------------
CREATE TABLE ProductTypes
(
    Id SMALLINT IDENTITY PRIMARY KEY,
    ProductType NVARCHAR(250) NOT NULL
);

INSERT INTO ProductTypes 
VALUES
	('Кольцо'),
	('серьги'),
	('Цепочка'),
	('Колье '),
	('Сувенир'),
	('Часы'),
	('Браслет'),
	('Бусы'),
	('Подвеска'),
	('Брошь'),
	('Булавка'),
	('Запонки'),
	('Зажим для галстука');

-- TABLE Customers ---------------------------------------------------
CREATE TABLE Customers
(
    Id INT IDENTITY PRIMARY KEY,
    Surname NVARCHAR(100) NOT NULL,
    [Name] NVARCHAR(100)  NOT NULL,
	Patronymic NVARCHAR(100),
	Addres NVARCHAR(250) NOT NULL,
	Phone VARCHAR(20) NOT NULL,
	Email VARCHAR(30) UNIQUE NOT NULL,

	CHECK((Surname !='') and ([Name] !='') 
						 and (Patronymic !='') 
						 and (Addres !='') 
						 and (Phone !='') 
						 and (Email !=''))
);

--TABLE FinishedProducts ---------------------------------------------------
CREATE TABLE FinishedProducts
(
    Id INT IDENTITY PRIMARY KEY,
    ProductType SMALLINT NOT NULL,
    ProductName NVARCHAR(250) NOT NULL,
	--Material (указан в сводной таблице)
	--Insertion (указан в сводной таблице)
	ProductWeight DECIMAL(9,2) NOT NULL, 
	--ProductSize (будет указываться при продаже) (размерный ряд указан для типа иделия)
	ProductPrice MONEY NOT NULL, --(цена по умолчанию)
	Discount DECIMAL(4,2), --(скидка на товар)

	CONSTRAINT FK_Products_To_ProductTypes FOREIGN KEY (ProductType)  REFERENCES ProductTypes (Id) ON DELETE NO ACTION ON UPDATE CASCADE,
);

INSERT INTO FinishedProducts (ProductType, ProductName, ProductWeight, ProductPrice, Discount)
VALUES
	(1, 'Изделие 1', 9, 5000, null),
	(1, 'Изделие 2', 8, 20000, null);	

-- Table Images ---------------------------------------------------
Create Table Images
	(Id INT  IDENTITY PRIMARY KEY,
	ImageName NVARCHAR(50),
	ImagePath NVARCHAR(100), -- путь к файлу на диске
	[Image] VARBINARY(max),
	[Format] VARCHAR(10));
	
INSERT INTO Images (ImageName, ImagePath, [Format], [Image])
	SELECT 'Изделие 1',  'ProductImg\1.jpg', 'image/jpg', BulkColumn
	FROM Openrowset( Bulk 'ProductImg\1.jpg', Single_Blob) as img
	union all
	SELECT 'Изделие 2', 'C:\Users\Z\Documents\SQL Server Management Studio\img\2.jpg', 'image/jpg', BulkColumn
	FROM Openrowset( Bulk 'C:\Users\Z\Documents\SQL Server Management Studio\img\2.jpg', Single_Blob) as img;
	
 ------------------------------------------------------------------
			Create Table Conformity_ImagesToFProduct
			(IdProduct INT  NOT NULL REFERENCES FinishedProducts (Id) ON DELETE CASCADE ON UPDATE CASCADE,
			 IdImage  INT  NOT NULL REFERENCES Images (Id) ON DELETE CASCADE ON UPDATE CASCADE,
			 
			 PRIMARY KEY(IdProduct, IdImage));

			Create Table Conformity_MaterialsToFProduct
			(IdProduct INT  NOT NULL REFERENCES FinishedProducts (Id) ON DELETE CASCADE ON UPDATE CASCADE,
			 IdMaterial INT  NOT NULL REFERENCES Materials (Id) ON DELETE CASCADE ON UPDATE CASCADE,
			 PRIMARY KEY(IdProduct, IdMaterial));
			 
			INSERT INTO Conformity_MaterialsToFProduct 
				VALUES
					(1, 11),
					(1, 12),
					(2, 4);
					
			Create Table Conformity_InsertionsToFProduct
			(IdProduct INT  NOT NULL REFERENCES FinishedProducts (Id) ON DELETE CASCADE ON UPDATE CASCADE,
			 IdMaterial INT  NOT NULL REFERENCES Insertions (Id) ON DELETE CASCADE ON UPDATE CASCADE,
			 Quantity SMALLINT NOT NULL DEFAULT 1,
			 PRIMARY KEY(IdProduct, IdMaterial));
			 
			INSERT INTO Conformity_InsertionsToFProduct 
				VALUES
					(1, 1, default),
					(2, 6, default),
					(2, 10, 15);

			Create Table Conformity_SizesToProductType
			(Id INT IDENTITY PRIMARY KEY,
			 IdProductType SMALLINT  NOT NULL REFERENCES ProductTypes (Id) ON DELETE CASCADE ON UPDATE CASCADE,
			 Size DECIMAL(3,1) NOT NULL DEFAULT 18.0,
			 
			 CHECK((Size > 13) and (Size < 100)));
			 
			 INSERT INTO Conformity_SizesToProductType
				VALUES
					(1, 16),
					(1, 17),
					(1, 17.5),
					(1, default),
					(1, 18.5),
					(1, 19),
					(1, 19.5),
					(3, 40),
					(3, 45),
					(3, 50),
					(3, 60),
					(3, 70),
					(3, 90);

-- TABLE Sales ---------------------------------------------------
CREATE TABLE Sales -- в процессе доработки
(
    Id INT IDENTITY PRIMARY KEY,
    Product INT NOT NULL, --(????)
	ProductSize decimal(3,1),
    Customer INT NOT NULL,
	SaleDate SMALLDATETIME NOT NULL,
	Quantity SMALLINT NOT NULL DEFAULT 1,
	DiscountedPrice MONEY NOT NULL, --(цена товара при наличии на него скидок)
	Discount DECIMAL(4,2), --(доп. скидка продажи)
	Delivery BIT NOT NULL DEFAULT 1,
	Comment NVARCHAR(400),


	CONSTRAINT FK_Sales_To_FProducts FOREIGN KEY (Product)  REFERENCES FinishedProducts (Id) ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FK_Sales_To_Customers FOREIGN KEY (Customer)  REFERENCES Customers (Id) ON DELETE NO ACTION ON UPDATE CASCADE
);

    
COMMIT;
