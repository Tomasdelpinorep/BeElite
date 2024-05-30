import { Component, HostBinding } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { PostService } from '../../../service/post/post.service';
import { ToastrService } from 'ngx-toastr';
import { environment } from '../../../environment/environtments';
import { customEmailValidator } from '../../../misc/validators';
import { AthleteDetails } from '../../../models/athlete-details';

@Component({
  selector: 'app-edit-athlete',
  standalone: false,
  templateUrl: './edit-athlete.component.html',
  styleUrl: './edit-athlete.component.scss'
})
export class EditAthleteComponent {
  @HostBinding('class.w-100') applyClass = true;
  username!: String;
  athleteDetails!: AthleteDetails;
  defaultProgramPicUrl: String = environment.defaultProfilePicUrl;
  selectedProfilePic = null;

  constructor(
    public postService: PostService,
    private route: ActivatedRoute,
    private router: Router,
    private toastr: ToastrService
  ) { }

  form: FormGroup = new FormGroup({
    name: new FormControl('', [Validators.required]),
    username: new FormControl('', Validators.required),
    email: new FormControl('', [Validators.required, customEmailValidator]),
  });

  ngOnInit(): void {
    this.username = this.route.snapshot.params['athleteUsername'];
    this.postService.findAthlete(this.username).subscribe((data: AthleteDetails) => {
      this.athleteDetails = data;

      this.form.patchValue({
        name: data.name,
        username: data.username,
        email: data.email
      });
    });
  }

  get f() {
    return this.form.controls;
  }

  submit() {
    if (this.form.valid) {
      this.postService.editUser(this.form.value, this.selectedProfilePic).subscribe({
        next: resp => {
          if (resp) {
            this.toastr.success("Athlete has been updated successfully.", "Success!");
            setTimeout(() => {
              this.router.navigate(["/admin/athletes"]);
            }, 1500);
          }
        },
        error: err => {
          this.toastr.error("There has been an error updating the athlete.");
        }
      });
    }
  }


  onFileSelected(event: any) {
    this.selectedProfilePic = event.target.files[0];
  }
} 