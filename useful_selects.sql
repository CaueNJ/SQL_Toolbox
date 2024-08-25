/*--------------------------------------------------------------------------------------------------------------------------------------------*/

-- Procurar qualquer coisa dentro do códigos dos objetos
-- Search for anything inside the objects code
select * 
from ALL_SOURCE
where upper(text) like '%UPDATE%' -- Retorna todos os objetos que possuem um update dentro do código deles
;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/

-- Exemplo de código que limita linhas de consulta e randomiza a ordem do resultado
-- Select that randomizes the return order and restrict the quantity of rows
select  *
from (
  select nm_paciente,
         nr_cirurgia, 
         nr_Atendimento, 
         dt_inicio_real 
  from cirurgia a
  where CD_SETOR_ATENDIMENTO= (116) -- Realizadas no setor desejado
  and ie_status_cirurgia=2 -- Concluída
  and to_date(dt_inicio_real) between TO_date (:dt_inicial) and TO_date (:dt_final) -- Parâmetros de data
  order by DBMS_RANDOM.VALUE
)
where 1=1
and rownum <= (select round(count(nr_cirurgia) * 10 / 100) 
               from cirurgia a
               where CD_SETOR_ATENDIMENTO= (116) -- Realizadas no setor desejado
               and ie_status_cirurgia=2 -- Concluída
               and to_date(dt_inicio_real) between TO_date (:dt_inicial) and TO_date (:dt_final) -- Parâmetros de data                                                                                 
               ) -- Mostrando apenas 10% das cirurgias realizadas
;  

/*--------------------------------------------------------------------------------------------------------------------------------------------*/

-- Remover formatação do BD para pegar exatamente o que está escrito no campo do programa. (Muito utilizado em campos LONG do Tasy EMR)
-- Remove text formatting from BD to extract the exact text from the software (Very often used while working with LONG attributes in Tasy EMR)
Select replace(REMOVE_FORMATACAO_RTF_HTML(CONVERT_LONG_TO_VARCHAR2('ds_texto','MED_TEXTO_PADRAO', 'NR_SEQUENCIA = '||NR_SEQUENCIA)),CHR(13),' ')ds_TEXTO
from MED_TEXTO_PADRAO A
where nm_usuario_nrec = 'joao'
;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/

-- "Forçando" tabela dual a criar linhas
-- "Forcing" dual table to create rows
SELECT LEVEL,
            to_char(add_months(to_date(trunc(sysdate,'month')),-(LEVEL-1)),'dd/mm/yyyy')dt_mes
FROM DUAL
CONNECT BY LEVEL <= 24
;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/

-- Localizar trigger vinculada a uma tabela
-- Find all triggers that are linked to a table
select * 
from USER_TRIGGERS 
where table_owner = 'ATENDIMENTO_PACIENTE'
;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/

-- Retornar mensagem de erro usando exception
-- Return an error message using Exception
EXCEPTION WHEN NO_DATA_FOUND THEN
raise_application_error(-20011,'Error! Please, contact an admin.');

/*--------------------------------------------------------------------------------------------------------------------------------------------*/
