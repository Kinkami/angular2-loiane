import { Subscription } from 'rxjs/Subscription';
import { ActivatedRoute, Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';

import { CursosService } from './cursos.service';

@Component({
  selector: 'app-cursos',
  templateUrl: './cursos.component.html',
  styleUrls: ['./cursos.component.css']
})
export class CursosComponent implements OnInit {

  cursos: any[];
  pagina: number;
  inscricao: Subscription;
  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private cursosService: CursosService) { }

  ngOnInit() {
    this.cursos = this.cursosService.getCursos();
    this.inscricao = this.route.queryParams.subscribe(
      (queryParams: any) => {
        this.pagina = queryParams['pagina'];
      }
    )
  }
  ngOnDestroy() {
    this.inscricao.unsubscribe();
  }

  proximaPagina(){
    // this.pagina++;
    this.router.navigate(
      ['/cursos'],{queryParams: {'pagina':++this.pagina}});
  }
}
