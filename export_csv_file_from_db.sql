declare

ds_assunto_email_w varchar2(255):='enviar-select-csv-email';
ds_email_origem_w varchar2(255):= 'caue.joaquim@email.com.br';
ds_email_destino_w varchar2(255):= 'caue.joaquim@email.com.br';

arq_texto_w utl_file.file_type; -- Recebe/Insere os dados no arquivo gerado no C: do banco
body_clob_w clob; -- Corpo do e-mail
dados_arquivo_bl_w blob; -- Recebe cada linha do cursor c01 em formato binario
nm_arquivo_w varchar2(255);
ds_local_w varchar2(255):= '/seu/caminho/'; -- Caminho da pasta onde sera criado o arquivo (Sempre ficara no C: do BD) 
quebra_linha_w raw(255);
ds_cabecalho_w varchar2(500):= ' IdentificacaoPessoa;Nome;CPF';                                                

-- Cursor com os dados de todos os beneficiarios ativos de um plano
cursor c01 is
    select pls_obter_dados_segurado(a.nr_sequencia,'C')  ||';'||
             substr(b.nm_pessoa_fisica,0,100) ||';'||
             b.nr_cpf ds_benef
             
    from pls_segurado a
    join pessoa_fisica b on (a.cd_pessoa_fisica = b.cd_pessoa_fisica)
    where pls_obter_dados_segurado(a.nr_sequencia,'DS') = 'Ativo'
    and a.IE_TIPO_SEGURADO = 'B' 
    order by decode(a.nr_seq_titular,null,'1','2') asc
;        


begin
  
    body_clob_w :='<email background="#fff" lang="pt-BR">
    <row style="background: #0075bf; ">
        <col style="background: #0075bf; color: #0075bf;">
            <p2>
                <text italic="true" bolder="true" foreground="#212529" size="3"></text>
            </p2>
        </col>
    </row>
    <row>
        <col>
            <p1>
                <center>
                    <text align="center" size="4" >Prezado(a) ,<br/><br/>
                        TESTE
                     </text><text align="center" size="4" foreground="#ff0000">
                    </text>
                 </center>   
            </p1>
            <info type="AUTOMATIC_EMAIL"></info>
        </col>
    </row>
    </email>'
    ;
    
    -- Estrutura de criacao do CSV
    begin
        /*-------------Cria uma variavel com os dados e formata para enviar como um CSV-------------*/
        nm_arquivo_w := 'Beneficiarios'||to_char(sysdate,'ddmmyyyy')||'.csv';                                        
        dados_arquivo_bl_w:= utl_raw.cast_to_raw(ds_cabecalho_w); -- Transforma os dados do cabecalho em binario e insere na variavel           
        quebra_linha_w := UTL_RAW.CAST_TO_RAW(chr(13)||chr(10)); -- Transforma o resultado da concatenacao em binario
        
        for vet in c01 -- Coloca as linhas do cursor dentro de um vetor para inserir uma de cada vez na variavel
        loop
            begin                    
                DBMS_LOB.APPEND(dados_arquivo_bl_w,quebra_linha_w); -- Adiciona a quebra de linha para estrutuar o CSV                    
                DBMS_LOB.APPEND(dados_arquivo_bl_w,utl_raw.cast_to_raw(vet.ds_benef)); -- Adiciona a linha com os dados do vetor                       
            end;
        end loop;
        /*--------------------------------------------------------------------------------------------------------*/   

        /*-------------Cria um arquivo no C: da base caso haja a necessidade-------------*/
        arq_texto_w := utl_file.fopen(ds_local_w,nm_arquivo_w,'W'); -- Cria ou abre o arquivo
        utl_file.put_line(arq_texto_w, ds_cabecalho_w); -- Insere primeiro o cabecalho no arquivo que esta aberto
        utl_file.fflush(arq_texto_w); -- Salva o dado no arquivo que esta aberto no momento
        
        for vetl in c01 loop -- Coloca as linhas do cursor dentro de um vetor para inserir uma de cada vez no arquivo
            begin
            utl_file.put_line(arq_texto_w,vetl.ds_benef); -- Insere o dado da linha no arquivo e pula uma linha
            utl_file.fflush(arq_texto_w); -- Salva o dado no arquivo que esta aberto no momento
            end;
        end loop;
        
        utl_file.fclose(arq_texto_w); -- Fecha o arquivo    
        /*----------------------------------------------------------------------------------------*/   
    end;
       
    enviar_email -- (exemplo)Function para enviar por e-mail e nao ser necessario ir direto no C: buscar o arquivo
    (
    'caue',
    ds_assunto_email_w,
    null,
    ds_email_origem_w,
    ds_email_destino_w,
    ds_email_origem_w,
    'A',
    body_clob_w,
    dados_arquivo_bl_w,
    nm_arquivo_w 
    );

end;
/
