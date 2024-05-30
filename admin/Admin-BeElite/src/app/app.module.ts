import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { MatButtonModule } from '@angular/material/button';
import { MatTableModule } from '@angular/material/table';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatMenuModule } from '@angular/material/menu';
import { MatIconModule } from '@angular/material/icon';
import { MatDividerModule } from '@angular/material/divider';
import { MatListModule } from '@angular/material/list';
import { MatCardModule } from '@angular/material/card';
import { AppComponent } from './app.component';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AdminCoachesComponent } from './ui/coaches/coaches.component';
import { CreateCoachComponent } from './ui/create/coaches/create.component';
import { EditComponent } from './ui/edit/coach/edit.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { LoginComponent } from './ui/login/login.component';
import { AppRoutingModule } from './app-routing.module';
import { HTTP_INTERCEPTORS, provideHttpClient, withFetch } from '@angular/common/http';
import { LoggerInterceptor } from './misc/logger.interceptor';
import { RemoveWrapperInterceptor } from './misc/remove.wrapper.interceptor';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { HeaderComponent } from './components/header/header.component';
import { NotFoundPageComponent } from './ui/not-found-page-component/not-found-page-component';
import { ToastrModule } from 'ngx-toastr';
import { AthletesComponent } from './ui/athletes/athletes.component';
import { EditAthleteComponent } from './ui/edit/athlete/edit-athlete.component';
import { CreateAthleteComponent } from './ui/create/athlete/create-athlete.component';
import { ProgramsComponent } from './ui/programs/programs.component';
import { EditProgramComponent } from './ui/edit/programs/edit-program.component';
import { CreateProgramComponent } from './ui/create/programs/create-program.component';

@NgModule({
  declarations: [
    LoginComponent,
    AppComponent,
    SidebarComponent,
    AdminCoachesComponent,
    CreateCoachComponent,
    EditComponent,
    HeaderComponent,
    NotFoundPageComponent,
    AthletesComponent,
    EditAthleteComponent,
    CreateAthleteComponent,
    ProgramsComponent,
    CreateProgramComponent,
    EditProgramComponent
  ],
  imports: [
    AppRoutingModule,
    BrowserModule,
    CommonModule,
    FormsModule,
    RouterModule,
    ReactiveFormsModule,
    MatSidenavModule,
    MatToolbarModule,
    MatMenuModule,
    MatIconModule,
    MatDividerModule,
    MatListModule,
    MatButtonModule,
    MatCardModule,
    MatTableModule,
    NgbModule,
    ToastrModule.forRoot()
  ],
  providers: [{ provide: HTTP_INTERCEPTORS, useClass: LoggerInterceptor, multi: true }, provideHttpClient(withFetch()), {
    provide: HTTP_INTERCEPTORS,
    useClass: RemoveWrapperInterceptor,
    multi: true
  }],
  bootstrap: [AppComponent]
})
export class AppModule { }
