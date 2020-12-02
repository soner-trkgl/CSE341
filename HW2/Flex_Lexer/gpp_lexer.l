
/*   Soner Türkoğlu - Gebze Technical University - Computer Engineering - Lecture Programming Languages Assignment 1*/

/*   Compilation tips    
 *	
 *	for lex file -> lex gpp_lexer.l
 *	for c file   -> gcc gpp_lexer.c
 *	for object file -> ./a.out
 *	
 */

%{
	#include <stdio.h>
	#include"token.h"  
	int oc_or_cc = 0;
	
%}



%%
[ \t]*							{return SPACE;}
\n 								{return NEW_LINE;}
(?i:and)						{return KW_AND;}
(?i:or)							{return KW_OR;}
(?i:not)						{return KW_NOT;}
(?i:equal)						{return KW_EQUAL;}
(?i:less)						{return KW_LESS;}
(?i:nil)						{return KW_NIL;}
(?i:list)						{return KW_LIST;}
(?i:append)						{return KW_APPEND;}
(?i:concat)						{return KW_CONCAT;}
(?i:set)						{return KW_SET;}
(?i:deffun)						{return KW_DEFFUN;}
(?i:for)						{return KW_FOR;}
(?i:if)							{return KW_IF;}
(?i:exit)						{return KW_EXIT;}
(?i:load)						{return KW_LOAD;}
(?i:disp)						{return KW_DISP;}
(?i:true)						{return KW_TRUE;}
(?i:false)						{return KW_FALSE;}
"+"								{return OP_PLUS;}
"-"								{return OP_MINUS;}
"/"								{return OP_DIV;}	
"*"								{return OP_MULT;}
"("								{return OP_OP;}
")"								{return OP_CP;}
"**"							{return OP_DBLMULT;}
\"								{++oc_or_cc; return (oc_or_cc % 2 == 1)?OP_OC:OP_CC;}
","								{return OP_COMMA;}
;;.*							{return COMMENT;}
0|[1-9][0-9]*					{return VALUE;}
[a-zA-Z][a-zA-Z0-9]*			{return IDENTIFIER;}
<<EOF>>							{yyterminate();}
.								{return SYNTAX_ERROR;}
%%

int yywrap(){return 1;}
int main(int argc , char** argv){

	const char arr[][13] = { "" , "" , "KW_AND" , "KW_OR" , "KW_NOT" , "KW_EQUAL" , "KW_LESS" , "KW_NIL" , "KW_LIST" , "KW_APPEND" , "KW_CONCAT", 
							"KW_SET" , "KW_DEFFUN" , "KW_FOR" , "KW_IF" , "KW_EXIT" , "KW_LOAD" , "KW_DISP" , "KW_TRUE" , "KW_FALSE" ,																			
							"OP_PLUS" , "OP_MINUS" , "OP_DIV" , "OP_MULT" ,	"OP_OP" , "OP_CP" , "OP_DBLMULT" , "OP_OC" , "OP_CC" ,"OP_COMMA" ,
							"COMMENT" , "VALUE" , "IDENTIFIER", "SYNTAX_ERROR" };




	FILE * p ;

	char temptex[256];
    int get_temp , get_token = -1, nth_line = 0 , flag = 1;

    // run as interpreter

	if(argc == 1){																												
		p = fopen("parsed_cpp.txt","w");
		if(p == NULL){
			printf("error occur while create parsed_cpp.txt !!!!");
		}
		else{
			while( flag ){
				get_token = yylex();
				temptex[0]='\0';
				if(get_token == NEW_LINE && nth_line == 0){
					flag = 0;
				}
				else if(get_token == NEW_LINE){
					nth_line = 0;
				}
				else{
					if(get_token == 1 || get_token == 2){
					}
					else{
						if( 2 < get_token && get_token < 34 ){							
							if(get_token == OP_PLUS || get_token == OP_MINUS ){
								get_temp = get_token;
								get_token = yylex();
								if( get_token == VALUE || get_token == OP_OP || get_token == OP_CP || get_token == COMMENT){
									fprintf(p, "%s\n", arr[get_temp - 1]);
									fprintf(p, "%s\n", arr[get_token - 1]);
									nth_line = 1;
								}
								else if( get_token == SPACE || get_token == NEW_LINE){
									fprintf(p, "%s\n", arr[get_temp - 1]);
									if (get_token == SPACE)
									{
										nth_line = 1; 
									}
									else{
										nth_line = 0;
									}
								}
								else{
									while( get_token != SPACE && get_token != NEW_LINE){
										strcat(temptex,yytext);
									}
									printf("SYNTAX_ERROR %s cannot be tokenized\n", temptex);
									fprintf(p,"SYNTAX_ERROR %s cannot be tokenized\n", temptex);
									flag = 0;
								}
							}
							else if(get_token == COMMENT ){
								while( yylex() != NEW_LINE ){
									
								}
								fprintf(p, "%s\n", arr[get_token - 1]);
								nth_line = 0;
							}
							else if(get_token == OP_OP || get_token == OP_CP){
								get_temp = get_token;
								get_token = yylex();
								if(get_token == SPACE){
									fprintf(p, "%s\n", arr[get_temp - 1]);
									nth_line = 1;
								}
								else if(get_token == NEW_LINE){
									fprintf(p, "%s\n", arr[get_temp - 1]);
									nth_line = 0;
								}
								else{
									fprintf(p, "%s\n", arr[get_temp - 1]);
									fprintf(p, "%s\n", arr[get_token - 1]);
									nth_line = 1;
								}
								
							}
							else{
								get_temp = get_token;
								get_token = yylex();
								if(get_token != OP_OP && get_token != OP_CP && get_token != SPACE && get_token != NEW_LINE && get_token != COMMENT){
									while(get_token != SPACE && get_token !=NEW_LINE){
										strcat(temptex , yytext);
										get_token=yylex();
										
									}
									printf("SYNTAX_ERROR %s cannot be tokenized\n", temptex);
									fprintf(p,"SYNTAX_ERROR %s cannot be tokenized\n", temptex);
									flag = 0;
								}
								else{
									if ( get_token == NEW_LINE ) 
									{	
										fprintf(p, "%s\n", arr[get_temp- 1]);
										nth_line = 0;
									}
									else if( get_token == SPACE ){
										fprintf(p, "%s\n", arr[get_temp- 1]);
										nth_line = 1;
									}
									else{
										fprintf(p, "%s\n", arr[get_temp- 1]);
										fprintf(p, "%s\n", arr[get_token- 1]);
										nth_line = 1;
									}
									
									
								
								}
								
							}
							if(get_token == NEW_LINE){
								nth_line = 0;
							}
						}
						else{
							while( get_token != SPACE && get_token != NEW_LINE ){
								strcat(temptex,yytext);
								get_token = yylex();
							}
							fprintf(p, "SYNTAX_ERROR %s cannot be tokenizedn", temptex);
							if (get_token == NEW_LINE )
							{
								nth_line = 0;
							}
							else{
								nth_line = 1;
							}
							
						}
							
					}	
				}
			}
			fclose(p);
		}
		
			
	}

	// run as reading file

	else if( argc > 1){
		yyin = fopen(argv[1],"r");
		if (yyin == NULL)
		{
			printf("error occur while %s file is opening (may be file not exist )!!!!\n",argv[1]);
		}
		else{
			p = fopen("parsed_cpp.txt","w");
			if(p==NULL){
				printf("error occur while create parsed_cpp.txx !!!!");
			}
			else{
				get_token = yylex();
				while( get_token != EOF_RETURN ){
					temptex[0]='\0';
					if(get_token == 1 || get_token == 2){
						get_token = yylex();
					}
					else if(get_token == EOF_RETURN){

					}
					else{
						if( 2 < get_token && get_token < 34 ){							
							if(get_token == OP_PLUS || get_token == OP_MINUS ){
								get_temp = get_token;
								get_token = yylex();
								if( get_token == VALUE || get_token == OP_OP || get_token == OP_CP || get_token == COMMENT){
									fprintf(p, "%s\n", arr[get_temp - 1]);
									fprintf(p, "%s\n", arr[get_token - 1]);
									get_token = yylex();
								}
								else if( get_token == SPACE || get_token == NEW_LINE || get_token == EOF_RETURN){
									fprintf(p, "%s\n", arr[get_temp - 1]);
								}
								else{
									while( get_token != SPACE && get_token != NEW_LINE && get_token != EOF_RETURN){
										strcat(temptex,yytext);
									}
									printf("SYNTAX_ERROR %s cannot be tokenized\n", temptex);
									fprintf(p,"SYNTAX_ERROR %s cannot be tokenized\n", temptex);
								}
							}
							else if(get_token == COMMENT ){
								get_token = yylex();
								while( yylex() != EOF_RETURN && yylex() != NEW_LINE ){
									
								}
								fprintf(p, "%s\n", arr[COMMENT - 1]);
							}
							else if(get_token == OP_OP || get_token == OP_CP){
								get_temp = get_token;
								get_token = yylex();
								if(get_token == SPACE || get_token == NEW_LINE || get_token == EOF_RETURN){
									fprintf(p, "%s\n", arr[get_temp - 1]);
									
								}
								else{
									fprintf(p, "%s\n", arr[get_temp - 1]);
									fprintf(p, "%s\n", arr[get_token - 1]);
									get_token = yylex();
								}
								
							}
							else{
								get_temp = get_token;
								get_token = yylex();
								if(get_token != OP_OP && get_token != OP_CP && get_token != SPACE && get_token != NEW_LINE && get_token != COMMENT && get_token != EOF_RETURN){
									while(get_token != SPACE && get_token !=NEW_LINE && get_token != EOF_RETURN){
										strcat(temptex , yytext);
										get_token=yylex();
										
									}
									printf("SYNTAX_ERROR %s cannot be tokenized\n", temptex);
									fprintf(p,"SYNTAX_ERROR %s cannot be tokenized\n", temptex);
								}
								else{
									if ( get_token == NEW_LINE || get_token == SPACE || get_token == EOF_RETURN) 
									{	
										fprintf(p, "%s\n", arr[get_temp- 1]);
										nth_line = 0;
									}
									else{
										fprintf(p, "%s\n", arr[get_temp- 1]);
										fprintf(p, "%s\n", arr[get_token- 1]);
										get_token = yylex();
									}
									
									
								
								}
								
							}
							
						}
						else{
							while( get_token != SPACE && get_token != NEW_LINE && get_token != EOF_RETURN){
								strcat(temptex,yytext);
								get_token = yylex();
							}
							fprintf(p, "SYNTAX_ERROR %s cannot be tokenizedn", temptex);
							
						}
					}
						
				}
				fclose(p);
				
					
			}
			
		}
		
	}
	else{
		printf("unrecognized command line arrgument\n");
		return -1;
	}
	fclose(p);
	return 1;
}