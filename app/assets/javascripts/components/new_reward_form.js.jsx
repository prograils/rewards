// jshint esnext:true
class NewRewardForm extends React.Component {
  constructor(...atrs){
    super(...atrs);
    this.state = { csrf_token: '', error_messages: '' };
    this.formSubmit = this.formSubmit.bind(this);
    this.sendFormDone = this.sendFormDone.bind(this);
    this.sendFormFail = this.sendFormFail.bind(this);
    this.hideErrors = this.hideErrors.bind(this);
    //this.componentDitMount = this.componentDitMount.bind(this);
  }
  componentWillMount(){
    this.setState({ csrf_token: $('meta[name=csrf-token]').attr('content') });
  }
  formSubmit(e){
    let $form = $(e.target);
    e.preventDefault();
    $.ajax({
      url: this.props.url,
      data: $form.serialize(),
      dataType: 'json',
      method: $form.attr('method')
    })
    .done(this.sendFormDone)
    .fail(this.sendFormFail);
    return false;
  }
  sendFormDone() {
    // this is bad, I know. But it's ok for now.
    $('#new_reward_form').find('input').val('');
    $('#new_reward_form').find('select option').removeAttr('selected');
    globalBroadcaster.emit('new_reward');
  }
  sendFormFail(xhr) {
    this.setState({ error_messages: xhr.responseJSON.error_string });
  }
  hideErrors(){
    this.setState({ error_messages: '' });
  }
  render() {
    const recipients = JSON.parse(this.props.recipients);
    const recipientsOptions = recipients.map((recipient, i) => {
      return (
        <option value={recipient.id} key={i}>{recipient.name}</option>
      );
    });
    return(
      <form id="new_reward_form" onSubmit={ this.formSubmit } method="POST">
        <input name="utf8" type="hidden" value="✓" />
        <input name="authenticity_token" type="hidden" value={ this.state.csrf_token } />
        <div className="form-errors">
          { this.state.error_messages }
        </div>
        <div className="form-inputs">
          <div className="input string required reward_description"><label className="string required" htmlFor="reward_description"><abbr title="required">*</abbr> Reason</label><input className="string required" required="required" aria-required="true" maxLength="255" size="255" type="text" name="reward[description]" id="reward_description" onChange={ this.hideErrors }/></div>
          <div className="input integer required reward_value"><label className="integer required" htmlFor="reward_value"><abbr title="required">*</abbr> Value</label><input className="numeric integer required" required="required" aria-required="true" min="0" type="number" step="1" name="reward[value]" id="reward_value" onChange={ this.hideErrors } /></div>
          <div className="input select required reward_recipient"><label className="select required" htmlFor="reward_recipient_id"><abbr title="required">*</abbr> Recipient</label>
            <select className="select required" required="required" aria-required="true" name="reward[recipient_id]" id="reward_recipient_id" onChange={ this.hideErrors }>
              <option value=""></option>
              { recipientsOptions }

            </select>
          </div>
        </div>
        <div className="form-actions">
          <button name="button" type="submit" value="Save reward" className="button btn btn-sm btn-info">Create Reward</button>
        </div>
      </form>
    );
  }
}
