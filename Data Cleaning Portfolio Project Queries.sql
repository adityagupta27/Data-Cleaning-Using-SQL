/*
Cleaning Data in SQL Queries
*/


Select *
From [Portfolio Project]..HousingData

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio Project]..HousingData


Update [Portfolio Project]..HousingData
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE [Portfolio Project]..HousingData
Add SaleDateConverted Date;

Update [Portfolio Project]..HousingData
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Portfolio Project]..HousingData
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..HousingData a
JOIN [Portfolio Project]..HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..HousingData a
JOIN [Portfolio Project]..HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Portfolio Project]..HousingData
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Portfolio Project]..HousingData


ALTER TABLE [Portfolio Project]..HousingData
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio Project]..HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Portfolio Project]..HousingData
Add PropertySplitCity Nvarchar(255);

Update [Portfolio Project]..HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [Portfolio Project]..HousingData





Select OwnerAddress
From [Portfolio Project]..HousingData


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Portfolio Project]..HousingData



ALTER TABLE [Portfolio Project]..HousingData
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio Project]..HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Portfolio Project]..HousingData
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio Project]..HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Portfolio Project]..HousingData
Add OwnerSplitState Nvarchar(255);

Update [Portfolio Project]..HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [Portfolio Project]..HousingData




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project]..HousingData
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project]..HousingData


Update [Portfolio Project]..HousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio Project]..HousingData
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Portfolio Project]..HousingData



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [Portfolio Project]..HousingData


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate