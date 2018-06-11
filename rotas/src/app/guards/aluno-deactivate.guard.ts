import { IFormCanDeactivate } from './iform-candeactivate';
import { Injectable } from '@angular/core';
import { AlunoFormComponent } from './../alunos/aluno-form/aluno-form.component';
import { CanDeactivate, RouterStateSnapshot, ActivatedRouteSnapshot } from '@angular/router';
import { Observable } from 'rxjs/Observable';

@Injectable()
export class AlunosDeactivateGuard implements CanDeactivate<IFormCanDeactivate>{

    canDeactivate(
        component: IFormCanDeactivate,
        route: ActivatedRouteSnapshot,
        state: RouterStateSnapshot
    ): Observable<boolean> | Promise<boolean> | boolean {
        console.log('guarda de desativação');
        
      //  return !component.formMudou;
      return component.podeDesativar();

    }
}