var Item = React.createClass({
  getInitialState: function() {
    return {
      imageUrl: this.props.image_url,
      description: this.props.description,
      title: this.props.title
    }
  },
  render: function() {
    return(
      <div>
          <header class="major special">
            <h2>{this.state.title}</h2>
            <p>{this.state.description}</p>
          </header>
        <img src={this.state.imageUrl} />
      </div>
      )
  },
})
