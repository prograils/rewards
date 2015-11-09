// jshint esnext:true
class Reward extends React.Component{
  constructor(...attr) {
    super(...attr);
  }

  componentWillMount() {
  }

  rewardClass() {
    let klass = 'green_reward';
    if(this.props.reward.is_stale)
      klass = 'blue_reward';
    if(this.props.reward.is_archived)
      klass = 'grey_reward';
    return klass;
  }

  render(){
    const reward = this.props.reward;
    return (
      <div className={ this.rewardClass() }>
        <div className="created_at">{ reward.created_at }</div>
        <div className="description">
          <a href={ reward.giver_path }>{ reward.giver }</a>
          <div className="glyphicon glyphicon-arrow-right" />
          <a href={ reward.recipient_path }>{ reward.recipient }</a>
          <div className="border">
            { reward.description }
            <div className="points">{ reward.value }</div>
          </div>

        </div>
      </div>
    );
  }
}
