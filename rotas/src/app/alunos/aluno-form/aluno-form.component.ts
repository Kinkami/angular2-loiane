import { IFormCanDeactivate } from './../../guards/iform-candeactivate';
import { Subscription } from 'rxjs/Subscription';
import { AlunosService } from '../alunos.service';
import { ActivatedRoute } from '@angular/router';
import { Component, OnInit } from '@angular/core';


@Component({
  selector: 'app-aluno-form',
  templateUrl: './aluno-form.component.html',
  styleUrls: ['./aluno-form.component.css']
})
export class AlunoFormComponent implements OnInit, IFormCanDeactivate {

  aluno: any;
  inscricao: Subscription;
  formMudou: boolean = false;

  constructor(private route: ActivatedRoute,
    private alunosService: AlunosService) { }

  ngOnInit() {
    this.inscricao = this.route.params.subscribe(
      (params: any) => {
        let id = params['id'];
        this.aluno = this.alunosService.getAluno(id);
        if (this.aluno === null) {
          this.aluno = {};
        }
      }
    );
  }

  ngOnDestroy() {
    this.inscricao.unsubscribe();
  }

  OnInput() {
    this.formMudou = true;
  }

  podeMudarRota() {
    if (this.formMudou) {
      confirm('Tem certeza que deseja sair dessa página?');
    }
  }

  podeDesativar() {
    return this.podeMudarRota();
  }

}