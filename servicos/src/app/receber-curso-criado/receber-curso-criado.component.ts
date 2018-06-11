import { Component, OnInit, EventEmitter } from '@angular/core';

import { CursosService } from '../cursos/cursos.service'

@Component({
  selector: 'app-receber-curso-criado',
  templateUrl: './receber-curso-criado.component.html',
  styleUrls: ['./receber-curso-criado.component.css']
})
export class ReceberCursoCriadoComponent implements OnInit {

  curso: string;
  constructor(private CursosService: CursosService) { }

  ngOnInit() {
    this.CursosService.emitirCursoCriado.subscribe(
      cursosCriado => this.curso = cursosCriado
    )
  }
}
