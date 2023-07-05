-- Standardize Date
SELECT * 
FROM dbo.housing


SELECT SaleDateConverted --CONVERT(DATE,SaleDate)
FROM dbo.housing

UPDATE dbo.housing
SET SaleDateConverted = CONVERT(DATE,SaleDate)

ALTER TABLE housing
ADD SaleDateConverted Date

--Populate Property Address
SELECT *
FROM dbo.housing
WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.housing a
JOIN dbo.housing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.housing a
JOIN dbo.housing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

-- Breaking out Address in individual columns

SELECT *
FROM dbo.housing
ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1,LEN(PropertyAddress)) as Address
FROM Projects.dbo.housing

ALTER TABLE Projects.dbo.housing
ADD PropertySpiltAddress Nvarchar(255)

ALTER TABLE Projects.dbo.housing
ADD PropertySpiltCity Nvarchar(255)

UPDATE Projects.dbo.housing
SET PropertySpiltAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)
UPDATE Projects.dbo.housing
SET PropertySpiltCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1,LEN(PropertyAddress))


SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Projects.dbo.housing

ALTER TABLE Projects.dbo.housing
ADD OwnerSpiltAddress Nvarchar(255)

ALTER TABLE Projects.dbo.housing
ADD OwnerSpiltCity Nvarchar(255)

ALTER TABLE Projects.dbo.housing
ADD OwnerSpiltState Nvarchar(255)

UPDATE Projects.dbo.housing
SET OwnerSpiltAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE Projects.dbo.housing
SET OwnerSpiltCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


UPDATE Projects.dbo.housing
SET OwnerSpiltState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT OwnerSpiltAddress,OwnerSpiltCity,OwnerSpiltState
FROM Projects.dbo.housing



--Change Y and N to Yes and No in "Sold as Vacant" column

SELECT SoldAsVacant,
Case
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Projects.dbo.housing

UPDATE Projects.dbo.housing
SET SoldAsVacant = Case
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

SELECT SoldAsVacant
FROM Projects.dbo.housing

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM Projects.dbo.housing
GROUP BY SoldAsVacant
ORDER BY 2


--Remove Duplicates


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
	ORDER BY ParcelID
)Row_Num
FROM Projects.dbo.housing
)
SELECT *
FROM RowNumCTE
WHERE Row_Num > 1


--Delete Unused Columns

SELECT *
FROM Projects.dbo.housing

ALTER TABLE Projects.dbo.housing
DROP COLUMN  PropertyAddress,SaleDate,OwnerAddress,TaxDistrict
