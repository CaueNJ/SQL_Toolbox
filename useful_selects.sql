
-- Verificar se existem correções da Philips
-- Search for Philips releases
select distinct a.cd_versao,
    a.nr_pacote,
    a.nr_release,
    substr(a.ds_motivo,1,200) ds_motivo,
    a.ie_compila,
    (select ds_funcao from funcao where cd_funcao = a.cd_funcao) ds_funcao,
    a.DT_INI_APLICACAO,
    a.dt_fim_aplicacao,
    a.NM_USUARIO_APLICACAO,
    a.nr_seq_ordem_serv
from ajuste_versao_cliente a
where a.cd_versao = '3.01.1713' -- Numero da versao
and ((NVL('T','T') = 'T') or (A.IE_COMPILA = 'T'))
and ((NVL('','X') = 'X') or (a.CD_FUNCAO = ''))
and (a.NR_PACOTE = 73)  
and a.nr_release = 707
--AND lower(a.ds_motivo) like '%rela%'    
--and lower(obter_nome_funcao(a.cd_funcao)) like '%emiss%'  
order by a.cd_versao,
         a.nr_release
;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/

-- Maneira mais facil de buscar parametros liberados no sistema
-- Easier way to sort for param's liberations
SELECT DISTINCT OBTER_NOME_FUNCAO(A.CD_FUNCAO)Funcao, 
       A.NR_SEQUENCIA Nr_param,
       SUBSTR(Obter_Desc_Expressao(CD_EXP_PARAMETRO, DS_PARAMETRO),1,254)DS_PARAMETRO,
       A.VL_PARAMETRO,
       A.DS_OBSERVACAO,
       Obter_Nome_Usuario(A.NM_USUARIO_PARAM) Nome_completo,
       A.NM_USUARIO Qm_liberou,
       A.DT_ATUALIZACAO
              
FROM FUNCAO_PARAM_USUARIO A,
        FUNCAO_PARAMETRO B

WHERE A.CD_FUNCAO = B.CD_FUNCAO
AND A.NR_SEQUENCIA = B.NR_SEQUENCIA
AND A.NM_USUARIO_PARAM = 'caue'
--AND UPPER(DS_PARAMETRO) LIKE '%ESTABELECIMENTO%'
--and lower(OBTER_NOME_FUNCAO(A.CD_FUNCAO)) like '%menu%sistema%'
ORDER BY OBTER_NOME_FUNCAO(A.CD_FUNCAO) ASC,
             a.nr_sequencia

/*--------------------------------------------------------------------------------------------------------------------------------------------*/

-- Select para consultar a tabela TUSS Mat/Med OPME 
select CD_MATERIAL_TUSS,
         DS_MATERIAL,
         NM_TECNICO,
         DS_APRESENTACAO,
         NR_REGISTRO_ANVISA,
         decode(IE_TIPO_ITEM,2,'Medicamento',1,'Material','Não informado') IE_TIPO_ITEM,
         nr_seq_carga_tuss seq_tabela_tuss
         
from TUSS_MATERIAL_ITEM
where 1=1 
and nr_seq_carga_tuss = 11 -- Tabela TUSS Mat/Med OPME 2021/02 
and cd_material_tuss = 79419623 -- Código TUSS do material
order by cd_material_tuss 
;

-- Select para consultar se existe um material com tal código TUSS vinculado (Operadoras)
select NR_SEQUENCIA,
         CD_MATERIAL_OPS CD_INTERNO,
         DS_MATERIAL,
         DS_NOME_COMERCIAL

from PLS_MATERIAL                                                       
where obter_dados_mat_tuss(nr_seq_tuss_mat_item,'C') = 78370540 -- Código TUSS do material
and IE_SITUACAO = 'A'
;
/*--------------------------------------------------------------------------------------------------------------------------------------------*/

-- Maneira mais facil de pesquisar os dominios
-- Easier way to search any domain
SELECT A.CD_DOMINIO,
       A.DS_DOMINIO,
       A.NM_DOMINIO,
       B.DS_VALOR_DOMINIO,
       B.VL_DOMINIO,
       B.IE_SITUACAO,
       C.CD_APLICACAO_TASY,
       A.IE_ALTERAR USUARIO_ALTERA
     
FROM DOMINIO A
JOIN VALOR_DOMINIO B ON (B.CD_DOMINIO = A.CD_DOMINIO)
JOIN MODULO_TASY C ON (C.NR_SEQUENCIA = A.NR_SEQ_MODULO)
--WHERE UPPER(B.DS_VALOR_DOMINIO) LIKE '%PRONTO SOCORRO%'
WHERE A.CD_DOMINIO = 10632
--WHERE UPPER(A.DS_DOMINIO) LIKE '%%'
;
