/*

cleaning data in SQL

*/

select *
from PortfolioProject.dbo.NashvileHousingData

--Date format

select saleDateConverted, convert(Date,saleDate)
from PortfolioProject.dbo.NashvileHousingData

Update portfolioProject.dbo.NashvileHousingData
SET SaleDate =  convert(Date,saleDate)

ALTER TABLE PortfolioProject.dbo.NashvileHousingData
Add SaleDateConverted Date


Update portfolioProject.dbo.NashvileHousingData
SET SaleDateConverted = CONVERT(Date,saleDate)


--Populate Property Address data

select *
from PortfolioProject.dbo.NashvileHousingData
--where PropertyAddress is null 
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvileHousingData a
 JOIN PortfolioProject.dbo.NashvileHousingData b
     on a.ParcelID = b.ParcelID
	 AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvileHousingData a
 JOIN PortfolioProject.dbo.NashvileHousingData b
     on a.ParcelID = b.ParcelID
	 AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


--Breaking Addresses into different columns (Address, City, State)

select  PropertyAddress
from PortfolioProject.dbo.NashvileHousingData
--where PropertyAddress is null 
--order by ParcelID


select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN (PropertyAddress)) as Address

from PortfolioProject.dbo.NashvileHousingData


ALTER TABLE PortfolioProject.dbo.NashvileHousingData
Add PropertySplitAddress nvarchar(255)


Update portfolioProject.dbo.NashvileHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.NashvileHousingData
Add PropertySplitCity nvarchar(255)


Update portfolioProject.dbo.NashvileHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN (PropertyAddress))


select *
from PortfolioProject.dbo.NashvileHousingData


select OwnerAddress
from PortfolioProject.dbo.NashvileHousingData

select
PARSENAME(REPLACE(OwnerAddress,',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress,',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)
from PortfolioProject.dbo.NashvileHousingData



ALTER TABLE PortfolioProject.dbo.NashvileHousingData
Add OwnerSplitAddress nvarchar(255)


Update portfolioProject.dbo.NashvileHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') , 3)

ALTER TABLE PortfolioProject.dbo.NashvileHousingData
Add OwnerSplitCity nvarchar(255)


Update portfolioProject.dbo.NashvileHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') , 2)


ALTER TABLE PortfolioProject.dbo.NashvileHousingData
Add OwnerSplitState nvarchar(255)


Update portfolioProject.dbo.NashvileHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)


--Change Y and N to Yes and No in column 'SoldAsVacant'

select Distinct(SoldAsVacant), count(SoldAsVacant)
from portfolioProject.dbo.NashvileHousingData
Group by SoldAsVacant
Order by 2


select SoldAsVacant,
 CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
from portfolioProject.dbo.NashvileHousingData


update portfolioProject.dbo.NashvileHousingData
 SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END

--Removing Duplicates

WITH RowNumCTE AS(
select *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  order by
				     UniqueID
					 ) row_num
from portfolioProject.dbo.NashvileHousingData
)
select *
from RowNumCTE
Where Row_num > 1
order by PropertyAddress


WITH RowNumCTE AS(
select *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  order by
				     UniqueID
					 ) row_num
from portfolioProject.dbo.NashvileHousingData
)
delete 
from RowNumCTE
Where Row_num > 1
--order by PropertyAddress


--Removing unused column

select *
from portfolioProject.dbo.NashvileHousingData


ALTER TABLE portfolioProject.dbo.NashvileHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE portfolioProject.dbo.NashvileHousingData
DROP COLUMN SaleDate

