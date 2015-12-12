var Item = React.createClass({
  getInitialState: function() {
    return {
      imageUrl: this.props.image_url
    }
  },
  render: function() {
    return(
      <div>
        <img src={this.state.imageUrl} />
      </div>
      )
  },
})
