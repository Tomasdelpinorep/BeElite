import { Component, HostBinding, TemplateRef } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { PostService } from '../../../service/post/post.service';
import { ToastrService } from 'ngx-toastr';
import { environment } from '../../../environment/environtments';
import { customEmailValidator } from '../../../misc/validators';
import { AthleteDetails } from '../../../models/athlete-details';
import { ProgramDetails } from '../../../models/program-details';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-edit-program',
  standalone: false,
  templateUrl: './edit-program.component.html',
  styleUrl: './edit-program.component.scss'
})
export class EditProgramComponent {
  @HostBinding('class.w-100') applyClass = true;
  coachUsername!: string;
  programName!: string;
  programDetails!: ProgramDetails;
  defaultProgramPicUrl: string = environment.defaultProfilePicUrl;
  selectedProfilePic = null;
  selectedWeekNumber!: number;
  selectedWeekName!: string;
  closeResult = "";

  constructor(
    public postService: PostService,
    private route: ActivatedRoute,
    private router: Router,
    private toastr: ToastrService,
    private modalService: NgbModal,
  ) { }

  form: FormGroup = new FormGroup({
    originalProgramName: new FormControl(''),
    coachUsername: new FormControl(''),
    programName: new FormControl('', [Validators.required]),
    programDescription: new FormControl('')
  });

  ngOnInit(): void {
    this.coachUsername = this.convertToURLFriendly(this.route.snapshot.params['coachUsername']);
    this.programName = this.route.snapshot.params['programName'];
    this.postService.findProgram(this.coachUsername, this.programName).subscribe((data: ProgramDetails) => {
      this.programDetails = data;

      this.form.patchValue({
        programName: data.programName,
        originalProgramName: this.programName,
        coachUsername: this.coachUsername,
        programDescription: data.description
      });
    });
  }

  get f() {
    return this.form.controls;
  }

  submit() {
    if (this.form.valid) {
      this.postService.editProgram(this.form.value, this.selectedProfilePic).subscribe({
        next: resp => {
          if (resp) {
            this.toastr.success("Program has been updated successfully.", "Success!");
            setTimeout(() => {
              this.router.navigate(["/admin/programs"]);
            }, 1500);
          }
        },
        error: err => {
          this.toastr.error("There has been an error updating the program.");
        }
      });
    }
  }

  deleteWeek() {
    this.postService.deleteWeek(this.coachUsername, this.programName, this.selectedWeekName, this.selectedWeekNumber).subscribe(res => {
      this.toastr.success("Week successfully deleted", "Success!");

      this.modalService.dismissAll();
      setTimeout(() => {
        window.location.reload();
      }, 2000)
    });
  }


  onFileSelected(event: any) {
    this.selectedProfilePic = event.target.files[0];
  }

  openConfirmationDialog(content: TemplateRef<any>, weekName: string, weekNumber: number) {
    this.selectedWeekNumber = weekNumber;
    this.selectedWeekName = weekName;

    this.modalService.open(content, { ariaLabelledBy: 'modal-basic-title' }).result.then(
      (result: any) => {
        this.closeResult = `Closed with: ${result}`;
      },
      (reason: any) => {
        this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
      },
    );
  }

  private getDismissReason(reason: any): string {
    switch (reason) {
      case ModalDismissReasons.ESC:
        return 'by pressing ESC';
      case ModalDismissReasons.BACKDROP_CLICK:
        return 'by clicking on a backdrop';
      default:
        return `with: ${reason}`;
    }
  }

  convertToURLFriendly(s: string){
    return s.replace(' ', "%20");
  }
} 