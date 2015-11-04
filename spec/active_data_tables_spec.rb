require_relative 'spec_helper'

shared_examples 'active_data_tables' do

  it 'includes the draw parameter in the result' do
    params[:draw] = '5'
    result = ActiveDataTables.find(subject, params)

    expect(result.draw).to eq(5)
  end

  describe 'applying paging' do

    before(:each) do
      params[:start] = 4
      params[:length] = 10
      @result = ActiveDataTables.find(subject, params)
    end

    it { expect(@result.records_total).to eq(6) }

    it { expect(@result.records_filtered).to eq(6) }

    it { expect(@result.data.length).to eq(2) }

    it { expect(@result.data) }

  end

  describe 'apply search on a single column' do

    before(:each) do
      params[:search][:value] = 'Single'
      @result = ActiveDataTables.find(subject, params)
    end

    it { expect(@result.records_total).to eq(6) }

    it { expect(@result.records_filtered).to eq(1) }

    it { expect(@result.data.length).to eq(1) }

    it { expect(@result.data) }

  end

  describe 'apply search on multiple columns' do

    before(:each) do
      params[:search][:value] = 'Presents'
      @result = ActiveDataTables.find(subject, params)
    end

    it { expect(@result.records_total).to eq(6) }

    it { expect(@result.records_filtered).to eq(3) }

    it { expect(@result.data.length).to eq(3) }

    it { expect(@result.data) }

  end

  describe 'apply descending sorting on a single column' do

    before(:each) do
      params[:order] = {}
      params[:order][:'0'] = { column: '0', dir: 'desc' }
      @result = ActiveDataTables.find(subject, params)
    end

    it { expect(@result.records_total).to eq(6) }

    it { expect(@result.records_filtered).to eq(6) }

    it { expect(@result.data[0].date).to eq(Time.new(2014, 1, 1, 0, 0, 6)) }

    it { expect(@result.data[5].date).to eq(Time.new(2014, 1, 1, 0, 0, 1)) }

  end

  describe 'apply ascending sorting on a single column' do

    before(:each) do
      params[:order] = {}
      params[:order][:'0'] = { column: '0', dir: 'asc' }
      @result = ActiveDataTables.find(subject, params)
    end

    it { expect(@result.records_total).to eq(6) }

    it { expect(@result.records_filtered).to eq(6) }

    it { expect(@result.data[0].date).to eq(Time.new(2014, 1, 1, 0, 0, 1)) }

    it { expect(@result.data[5].date).to eq(Time.new(2014, 1, 1, 0, 0, 6)) }

  end

end

RSpec.describe ActiveDataTables do

  let(:data) { [
    {date: Time.new(2014, 1, 1, 0, 0, 1), title: 'Single', description: 'My only Single'},
    {date: Time.new(2014, 1, 1, 0, 0, 2), title: 'Double', description: 'I''m a double'},
    {date: Time.new(2014, 1, 1, 0, 0, 3), title: 'Double', description: 'I''m another double'},
    {date: Time.new(2014, 1, 1, 0, 0, 4), title: 'Wedding', description: 'Marrying someone, get some presents'},
    {date: Time.new(2014, 1, 1, 0, 0, 5), title: 'Birthday', description: 'Presents'},
    {date: Time.new(2014, 1, 1, 0, 0, 6), title: 'Christmas', description: 'Presents'},
  ] }

  let(:params) {
    {
      draw: '5',
      start: '0',
      length: '10',
      search: { value: '', regex: 'false' },
      columns: {
        :'0' => { data: 'date',        name: '', searchable: 'false', orderable: 'true',  search: { value: '', regex: 'false' } },
        :'1' => { data: 'title',       name: '', searchable: 'true',  orderable: 'false', search: { value: '', regex: 'false' } },
        :'2' => { data: 'description', name: '', searchable: 'true',  orderable: 'false', search: { value: '', regex: 'false' } },
      }
    }
  }

  context 'Array data' do

    it_behaves_like 'active_data_tables' do
      subject { data.map { |d| OpenStruct.new(d) } }
    end

  end

  context 'ActiveRecord query' do
    require_relative 'support/event'

    before(:each) do
      data.each { |d| Event.create(date: d[:date], title: d[:title], description: d[:description]) }
    end

    after(:each) do
      Event.delete_all
    end

    it_behaves_like 'active_data_tables' do
      subject { Event }
    end

  end

end
