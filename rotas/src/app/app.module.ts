import { AlunosGuard } from './guards/alunos.guard';
import { CursosGuard } from './guards/cursos.guard';
import { AuthGuard } from './guards/auth.guard';

//import { AlunosModule } from './alunos/alunos.module';
//import { CursosModule } from './cursos/cursos.module';

import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { MaterializeModule } from 'angular2-materialize';
// import { CursosComponent } from './cursos/cursos.component';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
//  import { CursosService } from './cursos/cursos.service';
// import { routing } from './app.routing';
import { AppRoutingModule } from './app.routing.module';
import { AuthService } from './login/auth.service';
//import { AlunosComponent } from './alunos/alunos.component';
// import { CursoDetalheComponent } from './cursos/curso-detalhe/curso-detalhe.component';
// import { CursoNaoEncontradoComponent } from './cursos/curso-nao-encontrado/curso-nao-encontrado.component';

@NgModule({
  declarations: [
    AppComponent,
    // CursosComponent,
    HomeComponent,
    LoginComponent,
    // CursoDetalheComponent,
    // CursoNaoEncontradoComponent
  ],
  imports: [
    BrowserModule,
    MaterializeModule,
    // routing,
    // AlunosModule,
    AppRoutingModule,
    FormsModule,
    //CursosModule
  ],
  providers: [AuthService, AuthGuard, CursosGuard, AlunosGuard],
  bootstrap: [AppComponent]
})
export class AppModule { }
