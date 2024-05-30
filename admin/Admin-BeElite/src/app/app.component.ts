import { ChangeDetectorRef, Component, ElementRef, HostListener, Renderer2 } from '@angular/core';
import { SidebarService } from './service/sidebar-service';
import { NavigationEnd, Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'Admin-BeElite';
  isOverlap!: boolean;
  isSidebarVisible = true;
  isAuthorized = false;
  constructor(private sidebarService: SidebarService, private router: Router, private renderer: Renderer2, private el: ElementRef) { }

  ngOnInit() {
    this.sidebarService.sidebarVisibility$.subscribe((isVisible) => {
      this.isSidebarVisible = isVisible;
      this.checkOverlap();
    });

    this.router.events.subscribe(event => {
      if (event instanceof NavigationEnd && this.router.url.includes("/admin")) {
        this.isAuthorized = true;
      }
    })

    window.onload = () => {
      this.checkOverlap();
    };
  }

  checkOverlap() {
    const content = document.querySelector('.wrapper');
    const sidenav = document.querySelector('app-sidenav');

    if (content && sidenav) {
      const contentRect = content.getBoundingClientRect();
      const sidenavRect = sidenav.getBoundingClientRect();

      this.isOverlap = 190 > contentRect.left && this.isSidebarVisible; //Was supposed to be sidenavRect.right but that didn't give an accurate reading, so the width of the sidebar works fine
    }

    this.updateClasses();
  }

  @HostListener('window:resize', ['$event'])
  onResize(event: any) {
    this.checkOverlap();
  }

  updateClasses() {
    const content = this.el.nativeElement.querySelector('.wrapper');

    if (this.isOverlap) {
      this.renderer.addClass(content, 'with-sidebar');
      this.renderer.removeClass(content, 'without-sidebar');
    } else {
      this.renderer.addClass(content, 'without-sidebar');
      this.renderer.removeClass(content, 'with-sidebar');
    }
  }
}
