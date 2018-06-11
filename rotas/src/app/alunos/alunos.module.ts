import { AlunoDetalheResolver } from './guards/aluno-detalhe.resolver';
import { AlunosDeactivateGuard } from './../guards/aluno-deactivate.guard';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { AlunoFormComponent } from './aluno-form/aluno-form.component';
import { AlunoDetalheComponent } from './aluno-detalhe/aluno-detalhe.component';
import { AlunosRoutingModule } from './alunos.routing.module';
import { AlunosComponent } from './alunos.component';
import { AlunosService } from './alunos.service';

@NgModule({
    imports: [CommonModule,
        AlunosRoutingModule,
        FormsModule],
    declarations: [
        AlunosComponent,
        AlunoFormComponent,
        AlunoDetalheComponent],
    providers: [AlunosService,AlunosDeactivateGuard, AlunoDetalheResolver]
})
export class AlunosModule { }