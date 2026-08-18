      
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
      
      
      
      
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
      
      
      
      
      
--     Procedure Name:     sp_CDOSYS_SendMailX      
      
--     Project:     SQL Server Reinforcement      
      
--     Purpose:     To send mail using the Collaboration Data Objects for      
      
--                    
      
--     Notes:          References to the CDOSYS objects are at the following MSDN Web site:      
      
--               http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cdosys/html/_cdosys_messaging.asp      
--     creado el 2- febrero 2016    edgar castellanos cebrera        
--------------------------------------------------------------------------------------------      
      
alter PROCEDURE [dbo].[sp_CDOSYS_SendMail_HTMLx]      
    (         
          @From varchar(max) ,            
          @To varchar(max) ,            
          @Subject varchar(max)=" ",            
          @Body varchar(max) =" "  ,  
          @Importance varchar(5) = null  
     )        
AS      
     Declare @iMsg int      
     Declare @hr int      
     Declare @source varchar(255)      
     Declare @description varchar(500)      
     Declare @output varchar(1000)      
     Declare @ExchSvr varchar(40)   
	 
     set @ExchSvr = '.emerson.com'    ---- ///aqui va el  server  name   
     set @From =  'edgar.castellanos@emerson.com'     
   
-- Create the CDO.Message Object           
EXEC @hr = sp_OACreate 'CDO.Message', @iMsg OUT          
IF @hr <>0        
   BEGIN      
      SELECT @hr      
      EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT      
      IF @hr = 0      
         BEGIN      
            SELECT @output = '  Source: ' + @source      
            PRINT  @output      
            SELECT @output = '  Description: ' + @description      
            PRINT  @output      
            RETURN      
         END      
      ELSE      
         BEGIN      
            PRINT '  sp_OAGetErrorInfo failed.'      
            RETURN      
         END      
   END         
-- Configuring the Message Object         
-- This is to configure a remote SMTP server.         
-- http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cdosys/html/_cdosys_schema_configuration_sendusing.asp          
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusing").Value','2'           
IF @hr <>0            
   BEGIN       
      SELECT @hr      
      EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT      
      IF @hr = 0      
         BEGIN      
            SELECT @output = '  Source: ' + @source      
            PRINT  @output      
            SELECT @output = '  Description: ' + @description      
            PRINT  @output      
            GOTO CDOSYS_SendMail_cleanup      
         END      
      ELSE      
         BEGIN      
            PRINT '  sp_OAGetErrorInfo failed.'      
            GOTO CDOSYS_SendMail_cleanup      
         END      
   END      
 
-- This is to configure the Server Name or IP address.      
-- Replace MailServerName by the name or IP of your SMTP Server.      
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value', @ExchSvr      
IF @hr <>0      
   BEGIN      
      SELECT @hr      
      EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT      
      IF @hr = 0      
         BEGIN      
            SELECT @output = '  Source: ' + @source      
            PRINT  @output      
            SELECT @output = '  Description: ' + @description      
            PRINT  @output      
            GOTO CDOSYS_SendMail_cleanup      
              END      
      
 ELSE      
         BEGIN      
            PRINT '  sp_OAGetErrorInfo failed.'      
            GOTO CDOSYS_SendMail_cleanup      
         END      
   END        
-- Save the configurations to the message object.         
EXEC @hr = sp_OAMethod @iMsg, 'Configuration.Fields.Update', null        
IF @hr <>0      
   BEGIN      
      SELECT @hr      
      EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT      
      IF @hr = 0      
         BEGIN      
            SELECT @output = '  Source: ' + @source           
            PRINT  @output            
            SELECT @output = '  Description: ' + @description            
            PRINT  @output            
            GOTO CDOSYS_SendMail_cleanup            
       END           
      ELSE            
         BEGIN            
            PRINT '  sp_OAGetErrorInfo failed.'            
            GOTO CDOSYS_SendMail_cleanup           
         END            
   END                       
     -- Set the e-mail parameters.          
EXEC @hr = sp_OASetProperty @iMsg, 'To', @To        
IF @hr <>0      
   BEGIN           
      SELECT @hr          
      EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT           
      IF @hr = 0           
    BEGIN          
            SELECT @output = '  Source: ' + @source            
            PRINT  @output            
            SELECT @output = '  Description: ' + @description           
            PRINT  @output            
            GOTO CDOSYS_SendMail_cleanup            
         END            
      ELSE            
         BEGIN           
            PRINT '  sp_OAGetErrorInfo failed.'           
            GOTO CDOSYS_SendMail_cleanup           
         END            
   END            
EXEC @hr = sp_OASetProperty @iMsg, 'From', @From           
IF @hr <>0          
   BEGIN        
      SELECT @hr      
      EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT      
      IF @hr = 0      
         BEGIN      
            SELECT @output = '  Source: ' + @source      
            PRINT  @output      
            SELECT @output = '  Description: ' + @description      
            PRINT  @output      
            GOTO CDOSYS_SendMail_cleanup      
         END
      ELSE          
         BEGIN      
            PRINT '  sp_OAGetErrorInfo failed.'      
            GOTO CDOSYS_SendMail_cleanup      
         END        
   END      
EXEC @hr = sp_OASetProperty @iMsg, 'Subject', @Subject         
IF @hr <>0        
   BEGIN      
      SELECT @hr      
      EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT      
      IF @hr = 0      
         BEGIN      
            SELECT @output = '  Source: ' + @source      
            PRINT  @output      
            SELECT @output = '  Description: ' + @description      
            PRINT  @output      
            GOTO CDOSYS_SendMail_cleanup      
     END      
      ELSE      
         BEGIN      
            PRINT '  sp_OAGetErrorInfo failed.'      
            GOTO CDOSYS_SendMail_cleanup      
         END      
   END      
-- If you are using HTML e-mail, use 'HTMLBody' instead of 'TextBody'.       
EXEC @hr = sp_OASetProperty @iMsg, 'HTMLBody', @Body         
IF @hr <>0      
   BEGIN      
      SELECT @hr      
      EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT      
      IF @hr = 0      
         BEGIN      
            SELECT @output = '  Source: ' + @source      
            PRINT  @output      
            SELECT @output = '  Description: ' + @description      
       PRINT  @output      
            GOTO CDOSYS_SendMail_cleanup      
END 
ELSE
   BEGIN
 PRINT '  sp_OAGetErrorInfo failed.' 
  GOTO CDOSYS_SendMail_cleanup 
    END 
   END 
    --JUNIO 2026 
 -- Set the importance of the email. EXEC @hr = sp_OASetProperty @iMsg, 'Fields("urn:schemas:httpmail:importance").value', @Importance EXEC @hr = sp_OAMethod @iMsg, 'Fields.Update', null  
EXEC @hr = sp_OAMethod @iMsg, 'Send', NULL 
IF @hr <>0 
   BEGIN 
 SELECT @hr 
 EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT 
 IF @hr = 0 
   BEGIN 
      SELECT @output = '  Source: ' + @source 
      PRINT  @output 
      SELECT @output = '  Description: ' + @description 
      PRINT  @output 
      GOTO CDOSYS_SendMail_cleanup 
   END 
     ELSE 
    BEGIN 
  PRINT '  sp_OAGetErrorInfo failed.' 
  GOTO CDOSYS_SendMail_cleanup 
    END 
   END 
 
-- Do some error handling after each step if you have to. 
-- Clean up the objects created. 
CDOSYS_SendMail_cleanup: 
If (@iMsg IS NOT NULL) -- if @iMsg is NOT NULL then destroy it 
    BEGIN 
  EXEC @hr=sp_OADestroy @iMsg 
  -- handle the failure of the destroy if needed 
      IF @hr <>0 
      BEGIN 
   select @hr 
      EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT 
    -- if sp_OAGetErrorInfo was successful, print errors 
     IF @hr = 0 
   BEGIN 
   SELECT @output = '  Source: ' + @source 
  PRINT  @output 
  SELECT @output = '  Description: ' + @description 
  PRINT  @output 
     END 
    -- else sp_OAGetErrorInfo failed 
  ELSE 
     BEGIN 
   PRINT '  sp_OAGetErrorInfo failed.' 
       RETURN      
               END      
     END      
   END      
ELSE      
   BEGIN      
      PRINT ' sp_OADestroy skipped because @iMsg is NULL.'      
      RETURN      
   END      
      
      
      
      
      
      