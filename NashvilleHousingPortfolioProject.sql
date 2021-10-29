SELECT *
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- Standardise SaleDate

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

UPDATE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

-- Not Working, so let's alter the table (SaleDataConverted)

ALTER TABLE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
Add SaleDateConverted Date

UPDATE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data (If there is a reference point to base that off of; like ParcelID)

SELECT *
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
WHERE PropertyAddress is NULL

-- So lets look at everything and order by ParcelID

SELECT *
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
ORDER BY ParcelID

-- We see that there are duplicate ParcelId's that share the same property address
-- So if ParcelId A has an address, and another parcel A does not, we populate it with that same address
-- We need to join the table to itself in order to select the PropertyAddress from both tables, but where one is = NULL in order to see, in the other table, what the address is

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing a
JOIN PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing b
ON a.ParcelID = b. ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing a
JOIN PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing b
ON a.ParcelID = b. ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing a
JOIN PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing b
ON a.ParcelID = b. ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

-- Breaking out PropertyAdress and OwnerAddress into Individual Columns (Address, City, State)
-- PropertyAddress First

SELECT PropertyAddress
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) AS Address
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

-- After splitting the address from the city, we make 2 new columns

ALTER TABLE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
Add PropertySplitAddress nvarchar(255);

UPDATE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) - 1)

ALTER TABLE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
Add PropertySplitCity nvarchar(255);

UPDATE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) + 1, LEN(PropertyAddress))

-- OwnerAddress Second (But we're not using substrings this time)
-- Parsename doesn't work with commas so we need to change it to a period

SELECT OwnerAddress
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

SELECT PARSENAME(OwnerAddress, 1)
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
-- This doesn't work

SELECT PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3)
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
-- Change sequence

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

-- After splitting the address from the city, we make 2 new columns

-- First Address

ALTER TABLE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

UPDATE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3)

ALTER TABLE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
Add OwnerSplitCity nvarchar(255)

UPDATE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2)

ALTER TABLE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
Add OwnerSplitState nvarchar(255)

UPDATE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)

-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in SoldAsVacant

SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

UPDATE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates Through Creating CTE (Interchange the bottom SELECT with DELETE, and then back to SELECT to check if successful)

WITH RowNumCTE AS (
SELECT *, 
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
		          PropertyAddress,
				  SalePrice,
			      SaleDate,
			      LegalReference
				  ORDER BY
				     UniqueId 
				     ) AS RowNum

FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE RowNum > 1


------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing

ALTER TABLE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict

ALTER TABLE PortfolioProjectAlexTheAnalyst.dbo.NashvilleHousing
DROP COLUMN SaleDate -- Forgot this one