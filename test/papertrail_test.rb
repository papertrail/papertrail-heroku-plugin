require 'test/unit'
require 'mocha'
require 'heroku/command/base'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'papertrail'

class PtPluginTest < Test::Unit::TestCase

  def setup
    @pt = Heroku::Command::Pt.new
  end

  def stub_heroku_config(app, options, arguments)
    @pt.stubs(:app => app)
    mock_heroku = mock()
    mock_heroku.expects(:config_vars).with(app).returns(options)
    @pt.stubs(:heroku => mock_heroku)
    @pt.stubs(:args => arguments)
  end

  def expect_query(options, query)
    mock_search_query = mock()
    mock_connection = mock()
    mock_connection.expects(:query).with(query).returns(mock_search_query)
    Papertrail::Connection.expects(:new).with(options).returns(mock_connection)
    mock_search_query
  end

  def test_show_last_logs
    stub_heroku_config('my_rails_app', { 'PAPERTRAIL_API_TOKEN' => '1234' }, [])

    mock_query = expect_query({:token => '1234'}, [])
    mock_query.expects(:search).returns(stub(:events => ['event1']))

    $stdout.expects(:puts).with('event1')

    @pt.logs
  end

  def test_show_last_with_query
    stub_heroku_config('my_rails_app',
                       {'PAPERTRAIL_API_TOKEN' => '1234'},
                       %w(some arguments))

    mock_query = expect_query({:token => '1234'}, %w(some arguments))
    mock_query.expects(:search).returns(stub(:events => ['event1']))

    $stdout.expects(:puts).with('event1')

    @pt.logs
  end

  def test_tail_option
    stub_heroku_config('my_rails_app',
                       {'PAPERTRAIL_API_TOKEN' => '1234'},
                       %w(-t))

    mock_query = expect_query({:token => '1234'}, [])

    mock_query.expects(:search).returns(stub(:events => ['event1','event2']))
    $stdout.expects(:puts).with('event1')
    $stdout.expects(:puts).with('event2')
    $stdout.expects(:flush)

    mock_query.expects(:search).returns(stub(:events => ['event3']))
    $stdout.expects(:puts).with('event3')
    $stdout.expects(:flush)

    mock_query.expects(:search).returns(stub(:events => ['event4']))
    $stdout.expects(:puts).with('event4')
    $stdout.expects(:flush)

    # Pretend Ctrl-C happend during third sleep
    Kernel.stubs(:sleep).returns(nil,nil).then.raises(Interrupt)

    assert_raise( Interrupt) {@pt.logs}
  end

  def test_abort_when_empty_token
    stub_heroku_config('my_rails_app', {'PAPERTRAIL_API_TOKEN' => ''}, [])
    assert_raise( SystemExit) { @pt.logs}
  end

  def test_abort_when_no_token
    stub_heroku_config('my_rails_app', {'PAPERTRAIL_API_TOKEN' => nil}, '')
    assert_raise( SystemExit) { @pt.logs}
  end
end
