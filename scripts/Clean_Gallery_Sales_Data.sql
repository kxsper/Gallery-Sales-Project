DROP TABLE IF EXISTS Cleaned_Gallery_Sales_Data;

CREATE TABLE Cleaned_Gallery_Sales_Data (
    Sale_ID       TEXT PRIMARY KEY,
    SaleDate      TEXT NOT NULL,          -- Stored as 'YYYY-MM-DD'
    Artist        TEXT NOT NULL,
    ArtworkType   TEXT NOT NULL,
    Title         TEXT NOT NULL,
    Price_GBP     REAL NOT NULL,
    Quantity      INTEGER NOT NULL,
    Total_GBP     REAL NOT NULL,
    PaymentMethod TEXT NOT NULL,
    BuyerType     TEXT NOT NULL,
    AgeGroup      TEXT NOT NULL
);

WITH Ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY TRIM(REPLACE(REPLACE(Sale_ID, '_dup', ''), 'dup', ''))
               ORDER BY CASE WHEN Sale_ID NOT LIKE '%dup%' THEN 0 ELSE 1 END
           ) AS rn
    FROM Dirty_Gallery_Sales_Data
    WHERE SaleDate IS NOT NULL
      AND Artist    IS NOT NULL AND TRIM(Artist)    != ''
      AND Title     IS NOT NULL AND TRIM(Title)     != ''
      AND ArtworkType IS NOT NULL
      AND PaymentMethod IN ('CC', 'Cash', 'Bank Transfer')
      AND BuyerType     IN ('New', 'Repeat')
)

INSERT INTO Cleaned_Gallery_Sales_Data
SELECT
    TRIM(REPLACE(REPLACE(Sale_ID, '_dup', ''), 'dup', '')) AS Sale_ID,

    -- Keep original full date string when it looks correct, fallback otherwise
    CASE 
        WHEN LENGTH(TRIM(SaleDate)) = 10 
             AND SUBSTR(TRIM(SaleDate), 5,1) = '-' 
             AND SUBSTR(TRIM(SaleDate), 8,1) = '-' 
            THEN TRIM(SaleDate)
        ELSE TRIM(SaleDate) || '-01-01'   
    END AS SaleDate,

    -- Artist name standardisation
    CASE 
        WHEN Artist IN ('Andrei P', 'Andrei Protsouk') THEN 'Andrei Protsouk'
        WHEN Artist = 'Alisonjohnson'                  THEN 'Alison Johnson'
        ELSE TRIM(Artist)
    END AS Artist,

    TRIM(ArtworkType) AS ArtworkType,
    TRIM(Title)       AS Title,

    -- Unit price repair
    CASE 
        WHEN Price_GBP <= 0 AND Quantity <> 0 AND Total_GBP <> 0
            THEN ROUND(ABS(Total_GBP) / ABS(Quantity), 2)
        ELSE COALESCE(Price_GBP, 0)
    END AS Price_GBP,

    Quantity,

    -- Repair missing or suspicious Total_GBP
    CASE 
        WHEN Total_GBP IS NULL OR Total_GBP = '' OR ABS(Total_GBP) < 0.01
            THEN ROUND(COALESCE(Price_GBP, 0) * Quantity, 2)
        ELSE ROUND(Total_GBP, 2)
    END AS Total_GBP,

    TRIM(PaymentMethod) AS PaymentMethod,
    TRIM(BuyerType)     AS BuyerType,

    -- Age group cleaning
    CASE 
        WHEN AgeGroup LIKE '%35%' THEN '35-44'
        WHEN AgeGroup LIKE '%45%' THEN '45-54'
        WHEN AgeGroup LIKE '%55%' THEN '55+'
        WHEN AgeGroup IN ('UNK', 'unknown', '') THEN 'Unknown'
        ELSE TRIM(AgeGroup)
    END AS AgeGroup

FROM Ranked
WHERE rn = 1
ORDER BY SaleDate, Sale_ID
;

-- After running you should get 420 rows (460 original - 40 duplicates)
-- SELECT COUNT(*) FROM Cleaned_Gallery_Sales_Data;