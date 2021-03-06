

USE [Z_acompanhamento_mailing]
GO
/****** Object:  StoredProcedure [dbo].[USP_HORARIO_VERAO]    Script Date: 10/10/2017 14:25:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HORARIO_VERAO]



AS
BEGIN

    SET NOCOUNT off;



    SELECT DID AS CAMPANHA,
        '['+B.BASE +'].[DBO].['+ B.TABLENAME+']' AS [CALLFILE]
    INTO #CAMPANHAS
    FROM HN_ADMIN.DBO.CAMPAIGNS A JOIN HN_ADMIN.DBO.CALLFILE B
        ON          B.NAME = A.DBNAME
    WHERE         STATE=0
        and OutMode IN (3,2)
        AND DID NOT LIKE '%TESTE%'
        AND DID NOT LIKE '%AUDITORIA%'
        AND DID NOT LIKE '%CHECKLIST%'
    ORDER BY 1


    ALTER TABLE #CAMPANHAS ADD INDICE INT IDENTITY

    DECLARE @VOLTAS INT,@CONTADOR INT, @CAMPANHA VARCHAR(255),@CALLFILE VARCHAR(255),@MENSAGEM VARCHAR(255),@LINHAS_AFETADAS INT

    SET @CONTADOR = 1
    SET @VOLTAS = (SELECT COUNT(1)
    FROM #CAMPANHAS)

    WHILE @CONTADOR <= @VOLTAS  
BEGIN
        SET @CAMPANHA = (SELECT CAMPANHA
        FROM #CAMPANHAS
        WHERE INDICE = @CONTADOR)
        SET @CALLFILE = (SELECT CALLFILE
        FROM #CAMPANHAS
        WHERE INDICE = @CONTADOR)

        IF(DATEPART(HH,GETDATE()) IN (06,07,08,09)) --SEGUNDA A SÁBADO AS 07:00 
BEGIN
            PRINT @CAMPANHA
            --INSERE NO CALLFILE OS DDDS 81,41,42,43,44,45,46,61,62,64         
            EXEC(' PRINT ''INSERE NO CALLFILE OS DDDS 81,41,42,43,44,45,46,61,62,64''  
INSERT INTO '+@CALLFILE+' (INDICE,PRIORITE,DATE,HEURE,VERSOP,RAPPEL,TV,ID_TV,STATUSGROUP,STATUS,LIB_STATUS,DETAIL,LIB_DETAIL,HISTORIQUE,TEL1,ERRN1,TEL2,ERRN2,TEL3,ERRN3,TEL4,ERRN4,TEL5,ERRN5,TEL6,ERRN6,TEL7,ERRN7,TEL8,ERRN8,TEL9,ERRN9,TEL10,ERRN10,TEL,NBAPPELS,DUREE,NIVABS,MEMORAPPEL,MEMOVERSOP,TZBEGIN,TZEND,DATAMEMO,INTERNAL,RETRYLATER,MIXUP,PROFIL_RECORD,QUOTA_RECORD,LNG_WAV)          
SELECT A.INDICE, A.PRIORITE, A.DATE, A.HEURE, A.VERSOP, A.RAPPEL, A.TV, A.ID_TV, A.STATUSGROUP, A.STATUS, A.LIB_STATUS, A.DETAIL, A.LIB_DETAIL, A.HISTORIQUE, A.TEL1, A.ERRN1, A.TEL2, A.ERRN2, A.TEL3, A.ERRN3, A.TEL4, A.ERRN4, A.TEL5, A.ERRN5, A.TEL6, A.ERRN6, A.TEL7, A.ERRN7, A.TEL8, A.ERRN8, A.TEL9, A.ERRN9, A.TEL10, A.ERRN10, A.TEL, A.NBAPPELS, A.DUREE, A.NIVABS, A.MEMORAPPEL, A.MEMOVERSOP, A.TZBEGIN, A.TZEND, A.DATAMEMO, A.INTERNAL, A.RETRYLATER, A.MIXUP, A.PROFIL_RECORD, A.QUOTA_RECORD, A.LNG_WAV
FROM Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO A              
LEFT JOIN '+@CALLFILE+' C          
ON A.INDICE = C.INDICE                    
WHERE C.INDICE IS NULL 
AND A.CAMPANHA = '''+@CAMPANHA+'''         
AND (LEFT(REPLACE(A.TEL,''*'',''''),2) IN (81,41,42,43,44,45,46,61,62,64)              
  OR LEFT(REPLACE(A.TEL1,''*'',''''),2)  IN (81,41,42,43,44,45,46,61,62,64)               
  OR LEFT(REPLACE(A.TEL2,''*'',''''),2)  IN (81,41,42,43,44,45,46,61,62,64)                
  OR LEFT(REPLACE(A.TEL3,''*'',''''),2)  IN (81,41,42,43,44,45,46,61,62,64)                
  OR LEFT(REPLACE(A.TEL4,''*'',''''),2)  IN (81,41,42,43,44,45,46,61,62,64)                
  OR LEFT(REPLACE(A.TEL5,''*'',''''),2)  IN (81,41,42,43,44,45,46,61,62,64)                
  OR LEFT(REPLACE(A.TEL6,''*'',''''),2)  IN (81,41,42,43,44,45,46,61,62,64)                
  OR LEFT(REPLACE(A.TEL7,''*'',''''),2)  IN (81,41,42,43,44,45,46,61,62,64)               
  OR LEFT(REPLACE(A.TEL8,''*'',''''),2)  IN (81,41,42,43,44,45,46,61,62,64)               
  OR LEFT(REPLACE(A.TEL9,''*'',''''),2)  IN (81,41,42,43,44,45,46,61,62,64)               
  OR LEFT(REPLACE(A.TEL10,''*'',''''),2) IN (81,41,42,43,44,45,46,61,62,64))')

            SET @MENSAGEM = 'INSERE NO CALLFILE OS DDDS 81,41,42,43,44,45,46,61,62,64'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]



            --DELETA DO BACKUP          
            EXEC('PRINT ''DELETA DO BACKUP''  
DELETE A           
FROM Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO A              
JOIN '+@CALLFILE+' C          
ON A.INDICE = C.INDICE
WHERE A.CAMPANHA = '''+@CAMPANHA+'''')
            SET @MENSAGEM = 'DELETA DO BACKUP'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DUPLICADOS
            EXEC(' PRINT ''DELETA DO BACKUP OS DUPLICADOS'' 
DELETE T FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY INDICE,callfile ORDER BY INDICE) AS ROWNUMBER,* FROM [Z_ACOMPANHAMENTO_MAILING].dbo.FUSO_HORARIO )T
WHERE T.ROWNUMBER > 1')
            SET @MENSAGEM = 'DELETA DO BACKUP OS DUPLICADOS'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]



            --INSERE NO BACKUP DDDS 63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68 
            EXEC('PRINT ''INSERE NO BACKUP DDDS 63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68''  
INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO (INDICE,PRIORITE,DATE,HEURE,VERSOP,RAPPEL,TV,ID_TV,STATUSGROUP,STATUS,LIB_STATUS,DETAIL,LIB_DETAIL,HISTORIQUE,TEL1,ERRN1,TEL2,ERRN2,TEL3,ERRN3,TEL4,ERRN4,TEL5,ERRN5,TEL6,ERRN6,TEL7,ERRN7,TEL8,ERRN8,TEL9,ERRN9,TEL10,ERRN10,TEL,NBAPPELS,DUREE,NIVABS,MEMORAPPEL,MEMOVERSOP,TZBEGIN,TZEND,DATAMEMO,INTERNAL,RETRYLATER,MIXUP,PROFIL_RECORD,QUOTA_RECORD,LNG_WAV,CALLFILE,CAMPANHA)     
SELECT A.INDICE, A.PRIORITE, A.DATE, A.HEURE, A.VERSOP, A.RAPPEL, A.TV, A.ID_TV, A.STATUSGROUP, A.STATUS, A.LIB_STATUS, A.DETAIL, A.LIB_DETAIL, A.HISTORIQUE, A.TEL1, A.ERRN1, A.TEL2, A.ERRN2, A.TEL3, A.ERRN3, A.TEL4, A.ERRN4, A.TEL5, A.ERRN5, A.TEL6, A.ERRN6, A.TEL7, A.ERRN7, A.TEL8, A.ERRN8, A.TEL9, A.ERRN9, A.TEL10, A.ERRN10, A.TEL, A.NBAPPELS, A.DUREE, A.NIVABS, A.MEMORAPPEL, A.MEMOVERSOP, A.TZBEGIN, A.TZEND, A.DATAMEMO, A.INTERNAL, A.RETRYLATER, A.MIXUP, A.PROFIL_RECORD, A.QUOTA_RECORD, A.LNG_WAV,'''+@CALLFILE+''' CALLFILE ,'''+@CAMPANHA+''' CAMPANHA
FROM '+@CALLFILE+' A                    
LEFT JOIN Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO C          
ON A.INDICE = C.INDICE                    
WHERE C.INDICE IS NULL 
AND (LEFT(REPLACE(A.TEL,''*'',''''),2)   IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)               
  OR LEFT(REPLACE(A.TEL1,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)               
  OR LEFT(REPLACE(A.TEL2,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)                
  OR LEFT(REPLACE(A.TEL3,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)                
  OR LEFT(REPLACE(A.TEL4,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)                
  OR LEFT(REPLACE(A.TEL5,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)                
  OR LEFT(REPLACE(A.TEL6,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)                
  OR LEFT(REPLACE(A.TEL7,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)               
  OR LEFT(REPLACE(A.TEL8,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)               
  OR LEFT(REPLACE(A.TEL9,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68)               
  OR LEFT(REPLACE(A.TEL10,''*'',''''),2) IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68))')

            SET @MENSAGEM = 'INSERE NO BACKUP DDDS 63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99,65,66,67,69,92,95,97,68'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]
            --DELETA DO CALLFILE
            EXEC('PRINT ''DELETA DO CALLFILE ''  
DELETE A           
FROM '+@CALLFILE+' A           
JOIN Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO   B          
ON A.INDICE = B.INDICE
WHERE B.CAMPANHA = '''+@CAMPANHA+'''')

            SET @MENSAGEM = 'DELETA DO CALLFILE'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DUPLICADOS
            EXEC(' PRINT ''DELETA DO BACKUP OS DUPLICADOS'' 
DELETE T FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY INDICE,callfile ORDER BY INDICE) AS ROWNUMBER,* FROM [Z_ACOMPANHAMENTO_MAILING].dbo.FUSO_HORARIO )T
WHERE T.ROWNUMBER > 1')

            SET @MENSAGEM = 'DELETA DO BACKUP OS DUPLICADOS'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            IF(DATEPART(DW,GETDATE()) = 7) -- SÁBADO
BEGIN
                --ATUALIZA OS AGENDAMENTOS -  SÁBADO 
                EXEC('PRINT ''ATUALIZA OS AGENDAMENTOS''  
UPDATE A SET RAPPEL = LEFT(RAPPEL,1)+CONVERT(VARCHAR(8),GETDATE(),112)+''1032''           
FROM '+@CALLFILE+' A              
WHERE SUBSTRING(RAPPEL,2,12) <= CONVERT(VARCHAR(8),GETDATE(),112)+''1032''')
            END
ELSE
BEGIN
                --ATUALIZA OS AGENDAMENTOS  
                EXEC('PRINT ''ATUALIZA OS AGENDAMENTOS''  
UPDATE A SET RAPPEL = LEFT(RAPPEL,1)+CONVERT(VARCHAR(8),GETDATE(),112)+''0932''           
FROM '+@CALLFILE+' A              
WHERE SUBSTRING(RAPPEL,2,12) <= CONVERT(VARCHAR(8),GETDATE(),112)+''0932''')
            END

        END

ELSE IF(DATEPART(HH,GETDATE()) IN (10)) --SEGUNDA A SÁBADO AS 10:00 
BEGIN
            PRINT @CAMPANHA
            --INSERE NO CALLFILE DDDS 63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99 
            EXEC(' PRINT ''INSERE NO CALLFILE DDDS 63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99''  
INSERT INTO '+@CALLFILE+' (INDICE,PRIORITE,DATE,HEURE,VERSOP,RAPPEL,TV,ID_TV,STATUSGROUP,STATUS,LIB_STATUS,DETAIL,LIB_DETAIL,HISTORIQUE,TEL1,ERRN1,TEL2,ERRN2,TEL3,ERRN3,TEL4,ERRN4,TEL5,ERRN5,TEL6,ERRN6,TEL7,ERRN7,TEL8,ERRN8,TEL9,ERRN9,TEL10,ERRN10,TEL,NBAPPELS,DUREE,NIVABS,MEMORAPPEL,MEMOVERSOP,TZBEGIN,TZEND,DATAMEMO,INTERNAL,RETRYLATER,MIXUP,PROFIL_RECORD,QUOTA_RECORD,LNG_WAV)
SELECT A.INDICE, A.PRIORITE, A.DATE, A.HEURE, A.VERSOP, A.RAPPEL, A.TV, A.ID_TV, A.STATUSGROUP, A.STATUS, A.LIB_STATUS, A.DETAIL, A.LIB_DETAIL, A.HISTORIQUE, A.TEL1, A.ERRN1, A.TEL2, A.ERRN2, A.TEL3, A.ERRN3, A.TEL4, A.ERRN4, A.TEL5, A.ERRN5, A.TEL6, A.ERRN6, A.TEL7, A.ERRN7, A.TEL8, A.ERRN8, A.TEL9, A.ERRN9, A.TEL10, A.ERRN10, A.TEL, A.NBAPPELS, A.DUREE, A.NIVABS, A.MEMORAPPEL, A.MEMOVERSOP, A.TZBEGIN, A.TZEND, A.DATAMEMO, A.INTERNAL, A.RETRYLATER, A.MIXUP, A.PROFIL_RECORD, A.QUOTA_RECORD, A.LNG_WAV
FROM Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO A
LEFT JOIN '+@CALLFILE+' C
ON A.INDICE = C.INDICE
WHERE C.INDICE IS NULL 
AND A.CAMPANHA = '''+@CAMPANHA+''' 
AND (LEFT(REPLACE(A.TEL,''*'',''''),2)   IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99) 
  OR LEFT(REPLACE(A.TEL1,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99) 
  OR LEFT(REPLACE(A.TEL2,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99)  
  OR LEFT(REPLACE(A.TEL3,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99)  
  OR LEFT(REPLACE(A.TEL4,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99)
  OR LEFT(REPLACE(A.TEL5,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99)
  OR LEFT(REPLACE(A.TEL6,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99)
  OR LEFT(REPLACE(A.TEL7,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99)
  OR LEFT(REPLACE(A.TEL8,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99)
  OR LEFT(REPLACE(A.TEL9,''*'',''''),2)  IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99) 
  OR LEFT(REPLACE(A.TEL10,''*'',''''),2) IN(63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99))
AND (LEFT(REPLACE(A.TEL,''*'',''''),2)   <> 95 OR LEFT(REPLACE(A.TEL,''*'',''''),2)   IS NULL)
AND (LEFT(REPLACE(A.TEL1,''*'',''''),2)  <> 95 OR LEFT(REPLACE(A.TEL1,''*'',''''),2)  IS NULL)
AND (LEFT(REPLACE(A.TEL2,''*'',''''),2)  <> 95 OR LEFT(REPLACE(A.TEL2,''*'',''''),2)  IS NULL)
AND (LEFT(REPLACE(A.TEL3,''*'',''''),2)  <> 95 OR LEFT(REPLACE(A.TEL3,''*'',''''),2)  IS NULL)
AND (LEFT(REPLACE(A.TEL4,''*'',''''),2)  <> 95 OR LEFT(REPLACE(A.TEL4,''*'',''''),2)  IS NULL)
AND (LEFT(REPLACE(A.TEL5,''*'',''''),2)  <> 95 OR LEFT(REPLACE(A.TEL5,''*'',''''),2)  IS NULL)
AND (LEFT(REPLACE(A.TEL6,''*'',''''),2)  <> 95 OR LEFT(REPLACE(A.TEL6,''*'',''''),2)  IS NULL)
AND (LEFT(REPLACE(A.TEL7,''*'',''''),2)  <> 95 OR LEFT(REPLACE(A.TEL7,''*'',''''),2)  IS NULL)
AND (LEFT(REPLACE(A.TEL8,''*'',''''),2)  <> 95 OR LEFT(REPLACE(A.TEL8,''*'',''''),2)  IS NULL)
AND (LEFT(REPLACE(A.TEL9,''*'',''''),2)  <> 95 OR LEFT(REPLACE(A.TEL9,''*'',''''),2)  IS NULL)
AND (LEFT(REPLACE(A.TEL10,''*'',''''),2) <> 95 OR LEFT(REPLACE(A.TEL10,''*'',''''),2) IS NULL)')

            SET @MENSAGEM = 'INSERE NO CALLFILE DDDS 63,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,93,94,96,98,99'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]


            --DELETA DO BACKUP
            EXEC('PRINT ''DELETA DO BACKUP''  
DELETE A 
FROM Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO A
JOIN '+@CALLFILE+' C
ON A.INDICE = C.INDICE
WHERE A.CAMPANHA = '''+@CAMPANHA+'''')

            SET @MENSAGEM = 'DELETA DO BACKUP'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DUPLICADOS
            EXEC(' PRINT ''DELETA DO BACKUP OS DUPLICADOS'' 
DELETE T FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY INDICE,callfile ORDER BY INDICE) AS ROWNUMBER,* FROM [Z_ACOMPANHAMENTO_MAILING].dbo.FUSO_HORARIO )T
WHERE T.ROWNUMBER > 1')

            SET @MENSAGEM = 'DELETA DO BACKUP OS DUPLICADOS'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --ATUALIZA AGENDAMENTOS
            EXEC('PRINT ''ATUALIZA AGENDAMENTOS''  
UPDATE A SET RAPPEL = LEFT(RAPPEL,1)+CONVERT(VARCHAR(8),GETDATE(),112)+''1102'' 
FROM '+@CALLFILE+' A
WHERE SUBSTRING(RAPPEL,2,12) <= CONVERT(VARCHAR(8),GETDATE(),112)+''1102''')
        END  

ELSE IF(DATEPART(HH,GETDATE()) IN (11)) --SEGUNDA A SÁBADO AS 11:00 
BEGIN
            PRINT @CAMPANHA
            --INSERE NO CALLFILE O DDDS 65,66,67,69,68,92,97
            EXEC('PRINT ''INSERE NO CALLFILE O DDDS 65,66,67,69,68,92,97''  
INSERT INTO '+@CALLFILE+' (INDICE,PRIORITE,DATE,HEURE,VERSOP,RAPPEL,TV,ID_TV,STATUSGROUP,STATUS,LIB_STATUS,DETAIL,LIB_DETAIL,HISTORIQUE,TEL1,ERRN1,TEL2,ERRN2,TEL3,ERRN3,TEL4,ERRN4,TEL5,ERRN5,TEL6,ERRN6,TEL7,ERRN7,TEL8,ERRN8,TEL9,ERRN9,TEL10,ERRN10,TEL,NBAPPELS,DUREE,NIVABS,MEMORAPPEL,MEMOVERSOP,TZBEGIN,TZEND,DATAMEMO,INTERNAL,RETRYLATER,MIXUP,PROFIL_RECORD,QUOTA_RECORD,LNG_WAV)
SELECT A.INDICE, A.PRIORITE, A.DATE, A.HEURE, A.VERSOP, A.RAPPEL, A.TV, A.ID_TV, A.STATUSGROUP, A.STATUS, A.LIB_STATUS, A.DETAIL, A.LIB_DETAIL, A.HISTORIQUE, A.TEL1, A.ERRN1, A.TEL2, A.ERRN2, A.TEL3, A.ERRN3, A.TEL4, A.ERRN4, A.TEL5, A.ERRN5, A.TEL6, A.ERRN6, A.TEL7, A.ERRN7, A.TEL8, A.ERRN8, A.TEL9, A.ERRN9, A.TEL10, A.ERRN10, A.TEL, A.NBAPPELS, A.DUREE, A.NIVABS, A.MEMORAPPEL, A.MEMOVERSOP, A.TZBEGIN, A.TZEND, A.DATAMEMO, A.INTERNAL, A.RETRYLATER, A.MIXUP, A.PROFIL_RECORD, A.QUOTA_RECORD, A.LNG_WAV
FROM Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO A
LEFT JOIN '+@CALLFILE+' C
ON A.INDICE = C.INDICE
WHERE C.INDICE IS NULL 
AND A.CAMPANHA = '''+@CAMPANHA+''' 
AND (LEFT(REPLACE(A.TEL,''*'',''''),2)   IN (65,66,67,69,68,92,97) 
  OR LEFT(REPLACE(A.TEL1,''*'',''''),2)  IN (65,66,67,69,68,92,97) 
  OR LEFT(REPLACE(A.TEL2,''*'',''''),2)  IN (65,66,67,69,68,92,97)  
  OR LEFT(REPLACE(A.TEL3,''*'',''''),2)  IN (65,66,67,69,68,92,97)  
  OR LEFT(REPLACE(A.TEL4,''*'',''''),2)  IN (65,66,67,69,68,92,97)  
  OR LEFT(REPLACE(A.TEL5,''*'',''''),2)  IN (65,66,67,69,68,92,97)  
  OR LEFT(REPLACE(A.TEL6,''*'',''''),2)  IN (65,66,67,69,68,92,97)  
  OR LEFT(REPLACE(A.TEL7,''*'',''''),2)  IN (65,66,67,69,68,92,97) 
  OR LEFT(REPLACE(A.TEL8,''*'',''''),2)  IN (65,66,67,69,68,92,97) 
  OR LEFT(REPLACE(A.TEL9,''*'',''''),2)  IN (65,66,67,69,68,92,97) 
  OR LEFT(REPLACE(A.TEL10,''*'',''''),2) IN (65,66,67,69,68,92,97))')

            SET @MENSAGEM = 'INSERE NO CALLFILE O DDDS 65,66,67,69,68,92,97'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DO BACKUP 
            EXEC('PRINT ''DELETA DO BACKUP''  
DELETE A 
FROM Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO A
JOIN '+@CALLFILE+' C
ON A.INDICE = C.INDICE
WHERE A.CAMPANHA = '''+@CAMPANHA+'''')

            SET @MENSAGEM = 'DELETA DO BACKUP'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]


            --DELETA DUPLICADOS
            EXEC(' PRINT ''DELETA DO BACKUP OS DUPLICADOS'' 
DELETE T FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY INDICE,callfile ORDER BY INDICE) AS ROWNUMBER,* FROM [Z_ACOMPANHAMENTO_MAILING].dbo.FUSO_HORARIO )T
WHERE T.ROWNUMBER > 1')

            SET @MENSAGEM = 'DELETA DO BACKUP OS DUPLICADOS'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --ATUALIZA OS AGENDAMENTOS 
            EXEC('PRINT ''ATUALIZA OS AGENDAMENTOS''  
UPDATE A SET RAPPEL = LEFT(RAPPEL,1)+CONVERT(VARCHAR(8),GETDATE(),112)+''1102'' 
FROM '+@CALLFILE+' A
WHERE SUBSTRING(RAPPEL,2,12) <= CONVERT(VARCHAR(8),GETDATE(),112)+''1102''')
        END 

ELSE IF(DATEPART(HH,GETDATE()) IN (12)) --SEGUNDA A SÁBADO AS 11:00               
BEGIN
            PRINT @CAMPANHA
            --INSERE NO CALLFILE O DDD 95          
            EXEC('PRINT ''INSERE NO CALLFILE O DDD 95''  
INSERT INTO '+@CALLFILE+' (INDICE,PRIORITE,DATE,HEURE,VERSOP,RAPPEL,TV,ID_TV,STATUSGROUP,STATUS,LIB_STATUS,DETAIL,LIB_DETAIL,HISTORIQUE,TEL1,ERRN1,TEL2,ERRN2,TEL3,ERRN3,TEL4,ERRN4,TEL5,ERRN5,TEL6,ERRN6,TEL7,ERRN7,TEL8,ERRN8,TEL9,ERRN9,TEL10,ERRN10,TEL,NBAPPELS,DUREE,NIVABS,MEMORAPPEL,MEMOVERSOP,TZBEGIN,TZEND,DATAMEMO,INTERNAL,RETRYLATER,MIXUP,PROFIL_RECORD,QUOTA_RECORD,LNG_WAV)          
SELECT A.INDICE, A.PRIORITE, A.DATE, A.HEURE, A.VERSOP, A.RAPPEL, A.TV, A.ID_TV, A.STATUSGROUP, A.STATUS, A.LIB_STATUS, A.DETAIL, A.LIB_DETAIL, A.HISTORIQUE, A.TEL1, A.ERRN1, A.TEL2, A.ERRN2, A.TEL3, A.ERRN3, A.TEL4, A.ERRN4, A.TEL5, A.ERRN5, A.TEL6, A.ERRN6, A.TEL7, A.ERRN7, A.TEL8, A.ERRN8, A.TEL9, A.ERRN9, A.TEL10, A.ERRN10, A.TEL, A.NBAPPELS, A.DUREE, A.NIVABS, A.MEMORAPPEL, A.MEMOVERSOP, A.TZBEGIN, A.TZEND, A.DATAMEMO, A.INTERNAL, A.RETRYLATER, A.MIXUP, A.PROFIL_RECORD, A.QUOTA_RECORD, A.LNG_WAV
FROM Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO A              
LEFT JOIN '+@CALLFILE+' C          
ON A.INDICE = C.INDICE                    
WHERE C.INDICE IS NULL 
AND A.CAMPANHA = '''+@CAMPANHA+'''         
AND (LEFT(REPLACE(A.TEL,''*'',''''),2)   = 95                     
  OR LEFT(REPLACE(A.TEL1,''*'',''''),2)  = 95                     
  OR LEFT(REPLACE(A.TEL2,''*'',''''),2)  = 95                      
  OR LEFT(REPLACE(A.TEL3,''*'',''''),2)  = 95                      
  OR LEFT(REPLACE(A.TEL4,''*'',''''),2)  = 95                      
  OR LEFT(REPLACE(A.TEL5,''*'',''''),2)  = 95                      
  OR LEFT(REPLACE(A.TEL6,''*'',''''),2)  = 95                      
  OR LEFT(REPLACE(A.TEL7,''*'',''''),2)  = 95                     
  OR LEFT(REPLACE(A.TEL8,''*'',''''),2)  = 95                     
  OR LEFT(REPLACE(A.TEL9,''*'',''''),2)  = 95                     
  OR LEFT(REPLACE(A.TEL10,''*'',''''),2) = 95)')

            SET @MENSAGEM = 'INSERE NO CALLFILE O DDD 95'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DO BACKUP               
            EXEC('PRINT ''DELETA DO BACKUP''  
DELETE A           
FROM Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO A              
JOIN '+@CALLFILE+' C          
ON A.INDICE = C.INDICE
WHERE A.CAMPANHA = '''+@CAMPANHA+'''')

            SET @MENSAGEM = 'DELETA DO BACKUP '
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]



            --DELETA DUPLICADOS
            EXEC(' PRINT ''DELETA DO BACKUP OS DUPLICADOS'' 
DELETE T FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY INDICE,callfile ORDER BY INDICE) AS ROWNUMBER,* FROM [Z_ACOMPANHAMENTO_MAILING].dbo.FUSO_HORARIO )T
WHERE T.ROWNUMBER > 1')

            SET @MENSAGEM = 'DELETA DO BACKUP OS DUPLICADOS'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --ATUALIZA OS AGENDAMENTOS               
            EXEC('PRINT ''ATUALIZA OS AGENDAMENTOS''  
UPDATE A SET RAPPEL = LEFT(RAPPEL,1)+CONVERT(VARCHAR(8),GETDATE(),112)+''1202''           
FROM '+@CALLFILE+' A                    
WHERE SUBSTRING(RAPPEL,2,12) <= CONVERT(VARCHAR(8),GETDATE(),112)+''1202''')
        END               

ELSE IF(DATEPART(HH,GETDATE()) = 12) AND (DATEPART(DW,GETDATE()) = 7) -- SÁBADO AS 12:50
BEGIN

            --INSERE NO BACKUP DDDS 41,42,43,44,45,46,61,62,64 - PARANA E GIOAS - SÁBADO  
            EXEC('PRINT ''INSERE NO BACKUP DDDS 41,42,43,44,45,46,61,62,64 - PARANA E GIOAS - SÁBADO''  
INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO (INDICE,PRIORITE,DATE,HEURE,VERSOP,RAPPEL,TV,ID_TV,STATUSGROUP,STATUS,LIB_STATUS,DETAIL,LIB_DETAIL,HISTORIQUE,TEL1,ERRN1,TEL2,ERRN2,TEL3,ERRN3,TEL4,ERRN4,TEL5,ERRN5,TEL6,ERRN6,TEL7,ERRN7,TEL8,ERRN8,TEL9,ERRN9,TEL10,ERRN10,TEL,NBAPPELS,DUREE,NIVABS,MEMORAPPEL,MEMOVERSOP,TZBEGIN,TZEND,DATAMEMO,INTERNAL,RETRYLATER,MIXUP,PROFIL_RECORD,QUOTA_RECORD,LNG_WAV,CALLFILE,CAMPANHA) 
SELECT A.INDICE, A.PRIORITE, A.DATE, A.HEURE, A.VERSOP, A.RAPPEL, A.TV, A.ID_TV, A.STATUSGROUP, A.STATUS, A.LIB_STATUS, A.DETAIL, A.LIB_DETAIL, A.HISTORIQUE, A.TEL1, A.ERRN1, A.TEL2, A.ERRN2, A.TEL3, A.ERRN3, A.TEL4, A.ERRN4, A.TEL5, A.ERRN5, A.TEL6, A.ERRN6, A.TEL7, A.ERRN7, A.TEL8, A.ERRN8, A.TEL9, A.ERRN9, A.TEL10, A.ERRN10, A.TEL, A.NBAPPELS, A.DUREE, A.NIVABS, A.MEMORAPPEL, A.MEMOVERSOP, A.TZBEGIN, A.TZEND, A.DATAMEMO, A.INTERNAL, A.RETRYLATER, A.MIXUP, A.PROFIL_RECORD, A.QUOTA_RECORD, A.LNG_WAV,'''+@CALLFILE+''' CALLFILE ,'''+@CAMPANHA+''' CAMPANHA
FROM '+@CALLFILE+' A
LEFT JOIN Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO C
ON A.INDICE = C.INDICE
WHERE C.INDICE IS NULL 
AND (LEFT(REPLACE(A.TEL,''*'',''''),2)   IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL1,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL2,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL3,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL4,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL5,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL6,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL7,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL8,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL9,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL10,''*'',''''),2) IN(41,42,43,44,45,46,61,62,64))')

            SET @MENSAGEM = 'INSERE NO BACKUP DDDS 41,42,43,44,45,46,61,62,64 - PARANA E GIOAS - SÁBADO'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DO  CALLFILE
            EXEC('PRINT ''DELETA DO  CALLFILE''  
DELETE A 
FROM '+@CALLFILE+' A 
JOIN Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO B
ON A.INDICE = B.INDICE
WHERE B.CAMPANHA = '''+@CAMPANHA+'''')

            SET @MENSAGEM = 'DELETA DO  FUSO_HORARIO'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DUPLICADOS
            EXEC(' PRINT ''DELETA DO BACKUP OS DUPLICADOS'' 
DELETE T FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY INDICE,callfile ORDER BY INDICE) AS ROWNUMBER,* FROM [Z_ACOMPANHAMENTO_MAILING].dbo.FUSO_HORARIO )T
WHERE T.ROWNUMBER > 1')

            SET @MENSAGEM = 'DELETA DO BACKUP OS DUPLICADOS'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

        END

ELSE IF(DATEPART(HH,GETDATE()) = 17) AND (DATEPART(DW,GETDATE()) <> 7) -- SEGUNDA A SEXTA AS 17:50
BEGIN

            --INSERE NO BACKUP DDDS 41,42,43,44,45,46,61,62,64 - PARANA E GIOAS - SEGUNDA A SEXTA  
            EXEC('PRINT ''INSERE NO BACKUP DDDS 41,42,43,44,45,46,61,62,64 - PARANA E GIOAS - SEGUNDA A SEXTA''  
INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO (INDICE,PRIORITE,DATE,HEURE,VERSOP,RAPPEL,TV,ID_TV,STATUSGROUP,STATUS,LIB_STATUS,DETAIL,LIB_DETAIL,HISTORIQUE,TEL1,ERRN1,TEL2,ERRN2,TEL3,ERRN3,TEL4,ERRN4,TEL5,ERRN5,TEL6,ERRN6,TEL7,ERRN7,TEL8,ERRN8,TEL9,ERRN9,TEL10,ERRN10,TEL,NBAPPELS,DUREE,NIVABS,MEMORAPPEL,MEMOVERSOP,TZBEGIN,TZEND,DATAMEMO,INTERNAL,RETRYLATER,MIXUP,PROFIL_RECORD,QUOTA_RECORD,LNG_WAV,CALLFILE,CAMPANHA) 
SELECT A.INDICE, A.PRIORITE, A.DATE, A.HEURE, A.VERSOP, A.RAPPEL, A.TV, A.ID_TV, A.STATUSGROUP, A.STATUS, A.LIB_STATUS, A.DETAIL, A.LIB_DETAIL, A.HISTORIQUE, A.TEL1, A.ERRN1, A.TEL2, A.ERRN2, A.TEL3, A.ERRN3, A.TEL4, A.ERRN4, A.TEL5, A.ERRN5, A.TEL6, A.ERRN6, A.TEL7, A.ERRN7, A.TEL8, A.ERRN8, A.TEL9, A.ERRN9, A.TEL10, A.ERRN10, A.TEL, A.NBAPPELS, A.DUREE, A.NIVABS, A.MEMORAPPEL, A.MEMOVERSOP, A.TZBEGIN, A.TZEND, A.DATAMEMO, A.INTERNAL, A.RETRYLATER, A.MIXUP, A.PROFIL_RECORD, A.QUOTA_RECORD, A.LNG_WAV,'''+@CALLFILE+''' CALLFILE ,'''+@CAMPANHA+''' CAMPANHA
FROM '+@CALLFILE+' A
LEFT JOIN Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO C
ON A.INDICE = C.INDICE
WHERE C.INDICE IS NULL 
AND (LEFT(REPLACE(A.TEL,''*'',''''),2)   IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL1,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL2,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL3,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL4,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL5,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL6,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64)  
  OR LEFT(REPLACE(A.TEL7,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL8,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL9,''*'',''''),2)  IN(41,42,43,44,45,46,61,62,64) 
  OR LEFT(REPLACE(A.TEL10,''*'',''''),2) IN(41,42,43,44,45,46,61,62,64))')

            SET @MENSAGEM = 'INSERE NO BACKUP DDDS 41,42,43,44,45,46,61,62,64 - PARANA E GIOAS - SEGUNDA A SEXTA'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DO CALLFILE
            EXEC('PRINT ''DELETA DO CALLFILE ''  
DELETE A 
FROM '+@CALLFILE+' A 
JOIN Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO B
ON A.INDICE = B.INDICE
WHERE B.CAMPANHA = '''+@CAMPANHA+'''')

            SET @MENSAGEM = 'DELETA DO CALLFILE '
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DUPLICADOS
            EXEC(' PRINT ''DELETA DO BACKUP OS DUPLICADOS'' 
DELETE T FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY INDICE,callfile ORDER BY INDICE) AS ROWNUMBER,* FROM [Z_ACOMPANHAMENTO_MAILING].dbo.FUSO_HORARIO )T
WHERE T.ROWNUMBER > 1')

            SET @MENSAGEM = 'DELETA DO BACKUP OS DUPLICADOS'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]
        END
        
        /*Novo*/
ELSE IF(DATEPART(HH,GETDATE()) = 18) AND (DATEPART(DW,GETDATE()) <> 7) -- SEGUNDA A SEXTA AS 17:50 - INIBE ES
BEGIN

            --INSERE NO BACKUP DDDS 27,28 - SEGUNDA A SEXTA  
            EXEC('PRINT ''INSERE NO BACKUP DDDS 27,28 - PARANA E GIOAS - SEGUNDA A SEXTA''  
INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO (INDICE,PRIORITE,DATE,HEURE,VERSOP,RAPPEL,TV,ID_TV,STATUSGROUP,STATUS,LIB_STATUS,DETAIL,LIB_DETAIL,HISTORIQUE,TEL1,ERRN1,TEL2,ERRN2,TEL3,ERRN3,TEL4,ERRN4,TEL5,ERRN5,TEL6,ERRN6,TEL7,ERRN7,TEL8,ERRN8,TEL9,ERRN9,TEL10,ERRN10,TEL,NBAPPELS,DUREE,NIVABS,MEMORAPPEL,MEMOVERSOP,TZBEGIN,TZEND,DATAMEMO,INTERNAL,RETRYLATER,MIXUP,PROFIL_RECORD,QUOTA_RECORD,LNG_WAV,CALLFILE,CAMPANHA) 
SELECT A.INDICE, A.PRIORITE, A.DATE, A.HEURE, A.VERSOP, A.RAPPEL, A.TV, A.ID_TV, A.STATUSGROUP, A.STATUS, A.LIB_STATUS, A.DETAIL, A.LIB_DETAIL, A.HISTORIQUE, A.TEL1, A.ERRN1, A.TEL2, A.ERRN2, A.TEL3, A.ERRN3, A.TEL4, A.ERRN4, A.TEL5, A.ERRN5, A.TEL6, A.ERRN6, A.TEL7, A.ERRN7, A.TEL8, A.ERRN8, A.TEL9, A.ERRN9, A.TEL10, A.ERRN10, A.TEL, A.NBAPPELS, A.DUREE, A.NIVABS, A.MEMORAPPEL, A.MEMOVERSOP, A.TZBEGIN, A.TZEND, A.DATAMEMO, A.INTERNAL, A.RETRYLATER, A.MIXUP, A.PROFIL_RECORD, A.QUOTA_RECORD, A.LNG_WAV,'''+@CALLFILE+''' CALLFILE ,'''+@CAMPANHA+''' CAMPANHA
FROM '+@CALLFILE+' A
LEFT JOIN Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO C
ON A.INDICE = C.INDICE
WHERE C.INDICE IS NULL 
AND (LEFT(REPLACE(REPLACE(A.TEL ,''*'',''''),''-'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL1,''*'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL2,''*'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL3,''*'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL4,''*'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL5,''*'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL6,''*'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL7,''*'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL8,''*'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL9,''*'',''''),2)  IN (27,28) 
  OR LEFT(REPLACE(A.TEL10,''*'',''''),2) IN (27,28))')

            SET @MENSAGEM = 'INSERE NO BACKUP DDDS 27,28 - PARANA E GIOAS - SEGUNDA A SEXTA'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DO CALLFILE
            EXEC('PRINT ''DELETA DO CALLFILE ''  
DELETE A 
FROM '+@CALLFILE+' A 
JOIN Z_ACOMPANHAMENTO_MAILING.DBO.FUSO_HORARIO B
ON A.INDICE = B.INDICE
WHERE B.CAMPANHA = '''+@CAMPANHA+'''')

            SET @MENSAGEM = 'DELETA DO CALLFILE '
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]

            --DELETA DUPLICADOS
            EXEC(' PRINT ''DELETA DO BACKUP OS DUPLICADOS'' 
DELETE T FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY INDICE,callfile ORDER BY INDICE) AS ROWNUMBER,* FROM [Z_ACOMPANHAMENTO_MAILING].dbo.FUSO_HORARIO )T
WHERE T.ROWNUMBER > 1')

            SET @MENSAGEM = 'DELETA DO BACKUP OS DUPLICADOS'
            SET @LINHAS_AFETADAS = @@ROWCOUNT

            INSERT INTO Z_ACOMPANHAMENTO_MAILING.DBO.TFG_LOG_HORAIO_VERAO
                (DATA,MENSAGEM,LINHAS_AFETADAS)
            SELECT (SELECT GETDATE())[DATA], @MENSAGEM[MENSAGEM], @LINHAS_AFETADAS[LINHAS]
        END

        SET @CONTADOR = @CONTADOR + 1
    END
END 