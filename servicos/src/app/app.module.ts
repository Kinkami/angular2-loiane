
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { CursosService } from './cursos/cursos.service';
import { AppComponent } from './app.component';
import { CursosComponent } from './cursos/cursos.component';
import { CriarCursoModule } from './criar-curso/criar-curso.module';
import { LogService } from './shared/log.service';

@NgModule({
  declarations: [
    AppComponent,
    CursosComponent,  
    LogService
  ],
  imports: [
    BrowserModule,
    FormsModule,
    CriarCursoModule
    
  ],
  //providers: [CursosService],
  providers: [LogService],
  bootstrap: [AppComponent]
})
export class AppModule { }
