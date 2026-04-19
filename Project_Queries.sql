/*QUERY 1: Dialogue lines by movie:*/
SELECT 
    m.Movie_Title,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Movies m
LEFT JOIN dbo.Chapters_ c
    ON m.Movie_ID = c.Movie_ID
LEFT JOIN dbo.Dialogue d
    ON c.Chapter_ID = d.Chapter_ID
GROUP BY m.Movie_Title
ORDER BY dialogueCount DESC;


/*QUERY 2: Top 10 characters by dialogue lines*/
SELECT TOP 10
    c.Character_Name,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Characters c
LEFT JOIN dbo.Dialogue d
    ON c.Character_ID = d.Character_ID
GROUP BY c.Character_Name
ORDER BY dialogueCount DESC;


/*QUERY 3: Dialogue lines per movie + character*/
SELECT 
    m.Movie_Title,
    c.Character_Name,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Movies m
LEFT JOIN dbo.Chapters_ ch
    ON m.Movie_ID = ch.Movie_ID
LEFT JOIN dbo.Dialogue d
    ON ch.Chapter_ID = d.Chapter_ID
LEFT JOIN dbo.Characters c
    ON d.Character_ID = c.Character_ID
WHERE c.Character_Name IS NOT NULL
GROUP BY 
    m.Movie_Title,
    c.Character_Name
ORDER BY 
    m.Movie_Title,
    dialogueCount DESC;


/*QUERY 4: Top 10 most common places by dialogue lines*/
SELECT TOP 10
    p.Place_Name,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Places p
LEFT JOIN dbo.Dialogue d
    ON p.Place_ID = d.Place_ID
WHERE p.Place_Name IS NOT NULL
GROUP BY p.Place_Name
ORDER BY dialogueCount DESC;


/*QUERY 5: Most common places by movie*/
SELECT 
    m.Movie_Title,
    p.Place_Name,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Movies m
LEFT JOIN dbo.Chapters_ ch
    ON m.Movie_ID = ch.Movie_ID
LEFT JOIN dbo.Dialogue d
    ON ch.Chapter_ID = d.Chapter_ID
LEFT JOIN dbo.Places p
    ON d.Place_ID = p.Place_ID
WHERE p.Place_Name IS NOT NULL
GROUP BY 
    m.Movie_Title,
    p.Place_Name
ORDER BY 
    m.Movie_Title,
    dialogueCount DESC;


/*QUERY 6: Characters with more than 100 dialogue lines*/
SELECT 
    c.Character_Name,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Characters c
LEFT JOIN dbo.Dialogue d
    ON c.Character_ID = d.Character_ID
WHERE c.Character_Name IS NOT NULL
GROUP BY c.Character_Name
HAVING COUNT(d.Dialogue_ID) > 100
ORDER BY dialogueCount DESC;


/*Query 7: Dialogue lines in a selected place using a variable*/
DECLARE @PlaceName NVARCHAR(50);
SET @PlaceName = 'Astronomy Tower';

SELECT 
    p.Place_Name,
    c.Character_Name,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Places p
LEFT JOIN dbo.Dialogue d
    ON p.Place_ID = d.Place_ID
LEFT JOIN dbo.Characters c
    ON d.Character_ID = c.Character_ID
WHERE p.Place_Name = @PlaceName
  AND c.Character_Name IS NOT NULL
GROUP BY 
    p.Place_Name,
    c.Character_Name
ORDER BY dialogueCount DESC;


/*Query 8: Characters with above average dialogue lines*/
SELECT 
    c.Character_Name,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Characters c
LEFT JOIN dbo.Dialogue d
    ON c.Character_ID = d.Character_ID
WHERE c.Character_Name IS NOT NULL
GROUP BY c.Character_Name
HAVING COUNT(d.Dialogue_ID) > (
    SELECT AVG(dialogue_total)
    FROM (
        SELECT COUNT(Dialogue_ID) AS dialogue_total
        FROM dbo.Dialogue
        GROUP BY Character_ID
    ) AS sub
)
ORDER BY dialogueCount DESC;

/*Query 9: Top 3 characters overall*/
WITH CharacterCounts AS (
    SELECT 
        c.Character_Name,
        COUNT(d.Dialogue_ID) AS dialogueCount
    FROM dbo.Characters c
    LEFT JOIN dbo.Dialogue d
        ON c.Character_ID = d.Character_ID
    WHERE c.Character_Name IS NOT NULL
    GROUP BY c.Character_Name
)
SELECT TOP 3
    Character_Name,
    dialogueCount
FROM CharacterCounts
ORDER BY dialogueCount DESC;
/*Query 10: Average dialogue length by character*/
SELECT 
    c.Character_Name,
    AVG(LEN(d.Dialogue)) AS avgDialogueLength,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Characters c
LEFT JOIN dbo.Dialogue d
    ON c.Character_ID = d.Character_ID
WHERE c.Character_Name IS NOT NULL
  AND d.Dialogue IS NOT NULL
GROUP BY c.Character_Name
HAVING COUNT(d.Dialogue_ID) >= 10
ORDER BY avgDialogueLength DESC;


/*Query 11: Total spells cast per character*/
SELECT 
    c.Character_Name,
    COUNT(*) AS spellUseCount
FROM dbo.dialogue_spells ds
LEFT JOIN dbo.Dialogue d
    ON ds.dialogue_id = d.Dialogue_ID
LEFT JOIN dbo.Characters c
    ON d.Character_ID = c.Character_ID
WHERE c.Character_Name IS NOT NULL
GROUP BY 
    c.Character_Name
ORDER BY spellUseCount DESC;


/*Query 12: Total dialogue lines by place and movie*/
SELECT 
    m.Movie_Title,
    p.Place_Name,
    COUNT(d.Dialogue_ID) AS dialogueCount
FROM dbo.Movies m
LEFT JOIN dbo.Chapters_ ch
    ON m.Movie_ID = ch.Movie_ID
LEFT JOIN dbo.Dialogue d
    ON ch.Chapter_ID = d.Chapter_ID
LEFT JOIN dbo.Places p
    ON d.Place_ID = p.Place_ID
WHERE p.Place_Name IS NOT NULL
GROUP BY 
    m.Movie_Title,
    p.Place_Name
ORDER BY 
    m.Movie_Title,
    dialogueCount DESC;



-- =========================================
-- VIEW
-- =========================================
GO
CREATE VIEW vw_CharacterDialogueSummary AS
SELECT 
    c.Character_Name,
    COUNT(d.Dialogue_ID) AS totalLines,
    AVG(LEN(d.Dialogue)) AS avgLineLength
FROM dbo.Characters c
LEFT JOIN dbo.Dialogue d
    ON c.Character_ID = d.Character_ID
WHERE c.Character_Name IS NOT NULL
GROUP BY c.Character_Name;
 GO

-- =========================================
-- STORED PROCEDURE
-- =========================================
GO
CREATE PROCEDURE usp_GetTopCharactersByMovie
    @MovieID INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM dbo.Movies WHERE Movie_ID = @MovieID
    )
    BEGIN
        SELECT 
            m.Movie_Title,
            c.Character_Name,
            COUNT(d.Dialogue_ID) AS dialogueCount
        FROM dbo.Movies m
        LEFT JOIN dbo.Chapters_ ch
            ON m.Movie_ID = ch.Movie_ID
        LEFT JOIN dbo.Dialogue d
            ON ch.Chapter_ID = d.Chapter_ID
        LEFT JOIN dbo.Characters c
            ON d.Character_ID = c.Character_ID
        WHERE m.Movie_ID = @MovieID
          AND c.Character_Name IS NOT NULL
        GROUP BY 
            m.Movie_Title,
            c.Character_Name
        ORDER BY dialogueCount DESC;
    END
    ELSE
    BEGIN
        PRINT 'Movie ID not found';
    END
END;

EXEC usp_GetTopCharactersByMovie @MovieID = 2;

