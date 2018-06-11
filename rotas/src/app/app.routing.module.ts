import { AlunosGuard } from './guards/alunos.guard';
import { CursosGuard } from './guards/cursos.guard';
import { AuthGuard } from './guards/auth.guard';

import { Routes, RouterModule } from '@angular/router';
import { ModuleWithProviders, NgModule } from '@angular/core';

import { LoginComponent } from './login/login.component';
// import { CursosComponent } from './cursos/cursos.component';
import { HomeComponent } from './home/home.component';
// import { CursoNaoEncontradoComponent } from './cursos/curso-nao-encontrado/curso-nao-encontrado.component';
// import { CursoDetalheComponent } from './cursos/curso-detalhe/curso-detalhe.component';

const AppRoutes: Routes = [
    {
        path: 'cursos', loadChildren: 'app/cursos/cursos.module#CursosModule', 
        canActivate: [AuthGuard], 
        canActivateChild:[CursosGuard],
        canLoad: [AuthGuard]

    },
    { path: 'alunos', loadChildren: 'app/alunos/alunos.module#AlunosModule', 
    canActivate: [AuthGuard], //canActivateChild:[AlunosGuard]
    canLoad: [AuthGuard]
 },
    // { path: 'curso/:id', component: CursoDetalheComponent },
    // { path: 'cursos', component: CursosComponent },
    { path: 'login', component: LoginComponent },
    // { path: 'naoEncontrado', component: CursoNaoEncontradoComponent },
    { path: '', component: HomeComponent, canActivate: [AuthGuard] }
];


@NgModule({
    imports: [RouterModule.forRoot(AppRoutes, {useHash: true})],
    exports: [RouterModule]
})

export class AppRoutingModule {

}