// jshint esnext:true
class Rewards extends React.Component{
  // ES6 syntax - normally this is constructor(props, context) or sth similar
  constructor(...attr) {
    // funny part - you may forward those parameters further
    super(...attr);
    // initialize state
    this.state = { data: [], current_page: 1, total_pages: 0, total_count: 0 };
    // this is required to have access to state
    this.loadData = this.loadData.bind(this);
    this.loadDataDone = this.loadDataDone.bind(this);
  }

  componentDidMount() {
    this.loadData();
    globalBroadcaster.subscribe('new_reward', this.loadData);
  }

  loadData(page = 1){
    $.ajax({
      url: this.props.url + '?page=' + page,
      dataType: 'json'
    })
    .done(this.loadDataDone)
    .fail(this.loadDataFail);
  }



  loadDataDone(data){
    this.setState({data: data.rewards, current_page: data.current_page, total_pages: data.total_pages, total_count: data.total_count});
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
        <Pagination current_page={ this.state.current_page } total_pages={ this.state.total_pages } total_count={ this.state.total_count } onPaginationClick={this.loadData}/>
      </div>
    );
  }
}
