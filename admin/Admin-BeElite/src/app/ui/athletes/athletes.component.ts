import { Component, HostBinding, TemplateRef } from '@angular/core';
import { PostService } from '../../service/post/post.service';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { environment } from '../../environment/environtments';
import { UserDto } from '../../models/user-dto.intercace';

@Component({
  selector: 'app-athletes',
  templateUrl: './athletes.component.html',
  styleUrl: './athletes.component.scss'
})
export class AthletesComponent {
  @HostBinding('class.w-100') applyClass = true;
  closeResult = "";
  athleteList: UserDto[] = [];
  currentPage = 1;
  listSize!: number;
  defaultProfilePicUrl: String = environment.defaultProfilePicUrl;
  selectedAthleteUsername: String = "";
  apiBaseUrl = environment.apiBaseUrl;

  constructor(public postService: PostService, private modalService: NgbModal, private toastr: ToastrService) { }

  ngOnInit(): void {
    this.postService.getAllAthletes(this.currentPage - 1).subscribe(resp => {
      this.listSize = resp.totalElements;
      this.athleteList = resp.content;
      this.athleteList = this.athleteList.map(athlete => ({
        ...athlete,
        profilePicUrl: `${this.apiBaseUrl}open/profile-picture/${athlete.username}`
      }))
    });
  }

  deleteAthlete() {
    this.postService.delete(this.selectedAthleteUsername).subscribe(res => {
      this.toastr.success("Coach successfully deleted", "Success!");

      this.modalService.dismissAll();
      setTimeout(() => {
        window.location.reload();
      }, 2000)
    });
  }



  openConfirmationDialog(content: TemplateRef<any>, athleteUsername: String) {
    this.selectedAthleteUsername = athleteUsername;

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

  loadNewPage() {
    this.postService.getAllAthletes(this.currentPage - 1).subscribe(resp => {
      this.athleteList = resp.content;
    })

    if (this.athleteList.length == 1)
      window.location.reload();
  }
}
