import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CursosComponent } from './cursos.component';
import { CursosService } from './cursos.service';

@NgModule({
  declarations: [
    CursosService,
    CursosComponent
  ],
  imports: [
    CommonModule,
    FormsModule
  ],
  exports: [CursosComponent],
  providers: [CursosService]
})
export class CursosModule { }
