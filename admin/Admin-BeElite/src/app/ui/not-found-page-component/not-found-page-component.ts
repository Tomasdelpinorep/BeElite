import { Component, HostBinding } from '@angular/core';

@Component({
  selector: 'app-not-found-page-component',
  templateUrl: './not-found-page-component.html',
  styleUrl: './not-found-page-component.scss'
})
export class NotFoundPageComponent {
  @HostBinding('class.vw-100') applyClass = true;
}
