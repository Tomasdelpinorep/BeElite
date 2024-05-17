import { Component } from '@angular/core';
import { SidebarService } from './service/sidebar-service';
import { NavigationEnd, Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'Admin-BeElite';

  isSidebarVisible = true;
  isAuthorized = false;
  constructor(private sidebarService: SidebarService, private router: Router) {}

  ngOnInit() {
    this.sidebarService.sidebarVisibility$.subscribe((isVisible) => {
      console.log(isVisible)
      this.isSidebarVisible = isVisible;
    });

    this.router.events.subscribe(event => {
      if (event instanceof NavigationEnd && this.router.url.includes("/admin")){
        this.isAuthorized = true;
      }
    })
  }
}
