import { Routes } from '@angular/router';
import { ViewComponent } from './post/view/view.component';
import { CreateCoachComponent } from './post/create/coaches/create.component';
import { EditComponent } from './post/edit/edit.component';
import { AdminCoachesComponent } from './post/coaches/coaches.component';
import { AuthGuard } from './auth.guards';
import { LoginComponent } from './login/login.component';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  {
    path: 'admin',
    children: [
      { path: 'coaches', component: AdminCoachesComponent, canActivate: [AuthGuard] },
      { path: 'coaches/create', component: CreateCoachComponent, canActivate: [AuthGuard] },
      { path: 'coaches/edit', component: EditComponent, canActivate: [AuthGuard] },
      // { path: 'athletes', component: AdminAthletesPageComponent, canActivate: [AuthGuard] },
      // { path: 'programs', component: AdminProgramsPageComponent, canActivate: [AuthGuard] },
    ]
  },
];