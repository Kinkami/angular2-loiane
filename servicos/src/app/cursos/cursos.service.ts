
import { Injectable, EventEmitter } from '@angular/core';

import { LogService } from '../shared/log.service';

@Injectable()

export class CursosService {

    private cursos: string[] = ['Angular2', 'Java', 'C#'];

    emitirCursoCriado = new EventEmitter<string>();
    constructor(private LogService: LogService) {
        console.log('CursosComponent');
    }

    getCursos() {
        this.LogService.consoleLog('Obtendo lista de cursos');
        return this.cursos;
    }

    addCurso(curso: string) {
        this.LogService.consoleLog(`Criando um novo curso ${curso}`);
        this.cursos.push(curso);
        this.emitirCursoCriado.emit(curso);
    }
}