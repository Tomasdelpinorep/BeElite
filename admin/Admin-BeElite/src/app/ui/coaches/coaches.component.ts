import { Component, HostBinding, TemplateRef } from '@angular/core';
import { UserDto } from '../../models/user-dto.intercace';
import { PostService } from '../../service/post/post.service';
import { environment } from '../../environment/environtments';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-coaches',
  standalone: false,
  templateUrl: './coaches.component.html',
  styleUrl: './coaches.component.scss',
})
export class AdminCoachesComponent {
  @HostBinding('class.w-100') applyClass = true;
  closeResult = "";
  coachList: UserDto[] = [];
  currentPage = 1;
  listSize!: number;
  defaultProfilePicUrl: String = environment.defaultProfilePicUrl;
  selectedCoachUsername: String = "";
  apiBaseUrl: String = environment.apiBaseUrl;


  constructor(public postService: PostService, private modalService: NgbModal, private toastr: ToastrService) { }

  ngOnInit(): void {
    this.postService.getAllCoaches(this.currentPage - 1).subscribe(resp => {
      this.listSize = resp.totalElements;
      this.coachList = resp.content;
      this.coachList = this.coachList.map(coach => ({
        ...coach,
        profilePicUrl: `${this.apiBaseUrl}open/profile-picture/${coach.username}`
      }))
    });
  }

  deleteCoach() {
    this.postService.delete(this.selectedCoachUsername).subscribe(res => {
      this.toastr.success("Coach successfully deleted", "Success!");

      this.modalService.dismissAll();
      setTimeout(() => {
        window.location.reload();
      }, 2000)
    });
  }



  openConfirmationDialog(content: TemplateRef<any>, coachUsername: String) {
    this.selectedCoachUsername = coachUsername;

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
      this.coachList = resp.content;
    })

    if (this.coachList.length == 1)
      window.location.reload();
  }

}