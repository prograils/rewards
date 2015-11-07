// jshint esnext:true
class Rewards extends React.Component{
  constructor(...attr) {
    super(...attr);
    this.state = { data: [] };
    this.loadData = this.loadData.bind(this);
    this.loadDataDone = this.loadDataDone.bind(this);
  }

  componentDidMount() {
    this.loadData();
  }

  loadData(){
    $.ajax({
      url: this.props.url,
      dataType: 'json'
    })
    .done(this.loadDataDone)
    .fail(this.loadDataFail);
  }

  loadDataDone(data, textStatus, jqXHR){
    this.setState({data: data.rewards});
  }

  loadDataFail(xhr, status, err){
    console.error(this.props.url, status, err.toString());
  }

  render(){
    const rewardsList = this.state.data.map((reward, i) => {
      return (
        <Reward reward={reward} key={i} />
      )
    });

    return (
      <div className="reward-list">
        { rewardsList }
      </div>
    )
  }
}
