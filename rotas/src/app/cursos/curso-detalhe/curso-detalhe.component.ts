import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs/Subscription';

import { CursosService } from './../cursos.service';

@Component({
  selector: 'app-curso-detalhe',
  templateUrl: './curso-detalhe.component.html',
  styleUrls: ['./curso-detalhe.component.css']
})
export class CursoDetalheComponent implements OnInit {

  curso: any;
  id: number;
  isncricao: Subscription;
  constructor(private route: ActivatedRoute,
    private cursosService: CursosService,
    private router: Router
  ) {
    // console.log(this.route);
    // this.id = this.route.snapshot.params['id'];
  }

  ngOnInit() {
    this.isncricao = this.route.params.subscribe(
      (params: any) => {
        this.id = params['id'];
        this.curso = this.cursosService.getCurso(this.id);

        if (this.curso == null) {
this.router.navigate(['/cursos/naoEncontrado'])
        }
      }
    );
  }

  ngOnDestroy() {
    this.isncricao.unsubscribe();
  }

}
