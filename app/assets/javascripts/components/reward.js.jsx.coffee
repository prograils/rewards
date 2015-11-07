# @ is `window`:
class @Reward extends React.Component
  componentWillMount: ->
    klass = 'green_reward'
    klass = 'blue_reward' if this.props.is_stale
    klass = 'grey_reward' if this.props.is_archived
    this.setState( klass: klass )

  render: ->
    `<div className={ this.state.klass }>
      <div className="created_at">{ this.props.created_at }</div>
      <div className="description">
        <a href={ this.props.giver_path }>{ this.props.giver }</a>
        <div className="glyphicon glyphicon-arrow-right" />
        <a href={ this.props.recipient_path }>{ this.props.recipient }</a>
        <div className="border">
          { this.props.description }
          <div className="points">{ this.props.value }</div>
        </div>
      </div>
    </div>
    `
