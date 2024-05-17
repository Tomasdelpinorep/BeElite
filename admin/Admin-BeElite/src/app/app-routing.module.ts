import { RouterModule, Routes } from "@angular/router";
import { AdminCoachesComponent } from "./ui/coaches/coaches.component";
import { CreateCoachComponent } from "./ui/create/coaches/create.component";
import { EditComponent } from "./ui/edit/coach/edit.component";
import { LoginComponent } from "./ui/login/login.component";
import { AuthGuard } from "./misc/auth.guards";
import { NgModule } from "@angular/core";
import { NotFoundPageComponent } from "./ui/not-found-page-component/not-found-page-component";


const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  {
    path: 'admin',
    children: [
      { path: 'coaches', component: AdminCoachesComponent, canActivate: [AuthGuard] },
      { path: 'coaches/create', component: CreateCoachComponent, canActivate: [AuthGuard] },
      { path: 'coaches/edit/:coachUsername', component: EditComponent, canActivate: [AuthGuard] },
      // { path: 'athletes', component: AdminAthletesPageComponent, canActivate: [AuthGuard] },
      // { path: 'programs', component: AdminProgramsPageComponent, canActivate: [AuthGuard] },
    ]
  },
  {path: 'error-404', component: NotFoundPageComponent},
  {path: '**', redirectTo: 'error-404'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }