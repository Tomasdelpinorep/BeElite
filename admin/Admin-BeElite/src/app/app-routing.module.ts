import { RouterModule, Routes } from "@angular/router";
import { AdminCoachesComponent } from "./ui/coaches/coaches.component";
import { CreateCoachComponent } from "./ui/create/coaches/create.component";
import { EditComponent } from "./ui/edit/coach/edit.component";
import { LoginComponent } from "./ui/login/login.component";
import { AuthGuard } from "./misc/auth.guards";
import { NgModule } from "@angular/core";
import { NotFoundPageComponent } from "./ui/not-found-page-component/not-found-page-component";
import { AthletesComponent } from "./ui/athletes/athletes.component";
import { EditAthleteComponent } from "./ui/edit/athlete/edit-athlete.component";
import { CreateAthleteComponent } from "./ui/create/athlete/create-athlete.component";
import { ProgramsComponent } from "./ui/programs/programs.component";
import { EditProgramComponent } from "./ui/edit/programs/edit-program.component";
import { CreateProgramComponent } from "./ui/create/programs/create-program.component";


const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  {
    path: 'admin',
    children: [
      { path: 'coaches', component: AdminCoachesComponent, canActivate: [AuthGuard] },
      { path: 'coaches/create', component: CreateCoachComponent, canActivate: [AuthGuard] },
      { path: 'coaches/edit/:coachUsername', component: EditComponent, canActivate: [AuthGuard] },
      { path: 'athletes', component: AthletesComponent, canActivate: [AuthGuard] },
      { path: 'athletes/create', component: CreateAthleteComponent, canActivate: [AuthGuard] },
      { path: 'athletes/edit/:athleteUsername', component: EditAthleteComponent, canActivate: [AuthGuard] },
      { path: 'programs', component: ProgramsComponent, canActivate: [AuthGuard] },
      { path: 'programs/create', component: CreateProgramComponent, canActivate: [AuthGuard] },
      { path: 'programs/edit/:coachUsername/:programName', component: EditProgramComponent, canActivate: [AuthGuard] },
    ]
  },
  { path: 'error-404', component: NotFoundPageComponent },
  { path: '**', redirectTo: 'error-404' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }