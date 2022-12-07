import { LightningElement, wire } from "lwc";
import { fireEvent } from "c/pubsub";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import { FlowNavigationFinishEvent } from "lightning/flowSupport";

export default class UpdateLWCsFlow extends LightningElement {
  @wire(CurrentPageReference) pageRef;

  connectedCallback() {
    fireEvent(this.pageRef, "refreshPage", {});

    var actionClicked;
    var navigationEvent;
    if (actionClicked === "Next") {
      navigationEvent = new FlowNavigationNextEvent();
    } else if (actionClicked === "Finish") {
      navigationEvent = new FlowNavigationFinishEvent();
    }
  }
}