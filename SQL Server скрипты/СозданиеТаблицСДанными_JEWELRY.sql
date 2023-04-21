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
	('������', 375),
	('������', 500),
	('������', 583),
	('������', 585),
	('������', 750),
	('������', 958),
	('������', 999),
	('�������', 800),
	('�������', 830),
	('�������', 875),
	('�������', 925),
	('�������', 960),
	('�������', 999),
	('�������', 950),
	('�������', 850),
	('�������', 900),
	('��������', 500),
	('��������', 850),
	('�����', null),
	('�����', null),
	('�������', null),
	('������', null); 

-- TABLE Insertions ---------------------------------------------------
CREATE TABLE Insertions
(
    Id INT IDENTITY PRIMARY KEY,
    Insertion NVARCHAR(250) NOT NULL,
    Characteristic NVARCHAR(250)
);

INSERT INTO Insertions 
VALUES
	('�������� �����', null),
	('������� �����', null),
	('������', null),
	('������ � ��������������� ��������', '(H) ��. � 3/3�.���. 1-0.25���'),
	('��������', null),
	('�����', '(F) ��. �/1 1- 5.75���'),
	('������', '����������������, ������������'),
	('������', '��������� �������'),
	('���������', '(����) �� 57� 3/3-1-0.25���'),
	('���������', '�� 57B 1/3-1-0.5���'),
	('������', '(H) ��. � 3/3�.���. 1-0.25���'),
	('�������', '(O) �-41 2/�2 ���. 1-0.50���'),
	('������ ������', '(U)'),
	('��������', '(�)'),
	('������', null),
	('��������', null),
	('���������� ��������', null),
	('���������', null),
	('��������', '(O) �-41 2/�2 ���. 1-0.50���'),
	('�������', null);

-- TABLE ProductTypes ---------------------------------------------------
CREATE TABLE ProductTypes
(
    Id SMALLINT IDENTITY PRIMARY KEY,
    ProductType NVARCHAR(250) NOT NULL
);

INSERT INTO ProductTypes 
VALUES
	('������'),
	('������'),
	('�������'),
	('����� '),
	('�������'),
	('����'),
	('�������'),
	('����'),
	('��������'),
	('�����'),
	('�������'),
	('�������'),
	('����� ��� ��������');

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
	--Material (������ � ������� �������)
	--Insertion (������ � ������� �������)
	ProductWeight DECIMAL(9,2) NOT NULL, 
	--ProductSize (����� ����������� ��� �������) (��������� ��� ������ ��� ���� ������)
	ProductPrice MONEY NOT NULL, --(���� �� ���������)
	Discount DECIMAL(4,2), --(������ �� �����)

	CONSTRAINT FK_Products_To_ProductTypes FOREIGN KEY (ProductType)  REFERENCES ProductTypes (Id) ON DELETE NO ACTION ON UPDATE CASCADE,
);

INSERT INTO FinishedProducts (ProductType, ProductName, ProductWeight, ProductPrice, Discount)
VALUES
	(1, '������� 1', 9, 5000, null),
	(1, '������� 2', 8, 20000, null);	

-- Table Images ---------------------------------------------------
Create Table Images
	(Id INT  IDENTITY PRIMARY KEY,
	ImageName NVARCHAR(50),
	ImagePath NVARCHAR(100), -- ���� � ����� �� �����
	[Image] VARBINARY(max),
	[Format] VARCHAR(10));
	
INSERT INTO Images (ImageName, ImagePath, [Format], [Image])
	SELECT '������� 1',  'ProductImg\1.jpg', 'image/jpg', BulkColumn
	FROM Openrowset( Bulk 'ProductImg\1.jpg', Single_Blob) as img
	union all
	SELECT '������� 2', 'C:\Users\Z\Documents\SQL Server Management Studio\img\2.jpg', 'image/jpg', BulkColumn
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
CREATE TABLE Sales -- � �������� ���������
(
    Id INT IDENTITY PRIMARY KEY,
    Product INT NOT NULL, --(????)
	ProductSize decimal(3,1),
    Customer INT NOT NULL,
	SaleDate SMALLDATETIME NOT NULL,
	Quantity SMALLINT NOT NULL DEFAULT 1,
	DiscountedPrice MONEY NOT NULL, --(���� ������ ��� ������� �� ���� ������)
	Discount DECIMAL(4,2), --(���. ������ �������)
	Delivery BIT NOT NULL DEFAULT 1,
	Comment NVARCHAR(400),


	CONSTRAINT FK_Sales_To_FProducts FOREIGN KEY (Product)  REFERENCES FinishedProducts (Id) ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FK_Sales_To_Customers FOREIGN KEY (Customer)  REFERENCES Customers (Id) ON DELETE NO ACTION ON UPDATE CASCADE
);

    
COMMIT;
