--Cleaning Data in SQL

select*
from PortfolioProject..NashvilleHousing


--Standardize date format

select SaleDateConverted, cast(SaleDate as date)
from PortfolioProject..NashvilleHousing


alter table NashvilleHousing
add SaleDateConverted date


update NashvilleHousing
set SaleDateConverted = cast(SaleDate as date)


--populate property address data

Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select*
from PortfolioProject..NashvilleHousing
where PropertyAddress is null



--breaking Address into individual columns (Address, city, state)
select PropertyAddress
from PortfolioProject..NashvilleHousing

select 
SUBSTRING (propertyaddress,1,CHARINDEX(',',PropertyAddress) -1) As Address
, SUBSTRING (propertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(propertyaddress)) as City
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress varchar(255)


update NashvilleHousing
set PropertySplitAddress = SUBSTRING (propertyaddress,1,CHARINDEX(',',PropertyAddress) -1)


alter table NashvilleHousing
add City varchar(255)


update NashvilleHousing
set City = SUBSTRING (propertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(propertyaddress))

Select propertyaddress, PropertySplitAddress, City
from NashvilleHousing

--Spliting the Owners address

select OwnerAddress
from PortfolioProject..NashvilleHousing

select
PARSENAME (replace(OwnerAddress,',','.'),3)
,PARSENAME(replace(owneraddress,',', '.'),2)
,PARSENAME(replace(owneraddress,',', '.'),1)
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
Add OwnerSplitAddress varchar (255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME (replace(OwnerAddress,',','.'),3)

alter table NashvilleHousing
Add OwnerSplitCity varchar (255)

update NashvilleHousing
set OwnerSplitCity = PARSENAME (replace(OwnerAddress,',','.'),2)

alter table NashvilleHousing
Add OwnerSplitState varchar (255)

update NashvilleHousing
set OwnerSplitState = PARSENAME (replace(OwnerAddress,',','.'),1)

select OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
from NashvilleHousing


--change Y and N int YES and No

select distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'y' then 'Yes'
	when SoldAsVacant= 'n' then 'No'
	else SoldAsVacant
	end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant= 
case when SoldAsVacant = 'y' then 'Yes'
	when SoldAsVacant= 'n' then 'No'
	else SoldAsVacant
	end
SELECT*
FROM PortfolioProject..NashvilleHousing


--deleting unused columns

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN PropertyAddress, saledate, owneraddress