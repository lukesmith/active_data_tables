#require_relative '../feature_spec_helper'
require_relative '../lib/active_data_tables'

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
    {date: Time.new(2014, 1, 1, 0, 0, 1)},
    {date: Time.new(2014, 1, 1, 0, 0, 2)},
    {date: Time.new(2014, 1, 1, 0, 0, 3)},
    {date: Time.new(2014, 1, 1, 0, 0, 4)},
    {date: Time.new(2014, 1, 1, 0, 0, 5)},
    {date: Time.new(2014, 1, 1, 0, 0, 6)},
  ] }

  let(:params) {
    {
      draw: '5',
      start: '0',
      length: '10',
      search: { value: '', regex: 'false' },
      columns: {
        :'0' => { data: 'date',        name: '', searchable: 'true', orderable: 'true',  search: { value: '', regex: 'false' } },
        :'1' => { data: 'description', name: '', searchable: 'true', orderable: 'false', search: { value: '', regex: 'false' } },
      }
    }
  }

  context 'Array data' do

    it_behaves_like 'active_data_tables' do
      subject { data.map { |d| OpenStruct.new(d) } }
    end

  end

  context 'ActiveRecord query', skip: true do

    describe '#find' do

      before(:each) do
        data.each { |d| FactoryGirl.create(:event, date: d[:date]) }
      end

      it_behaves_like 'active_data_tables' do
        subject { Event }
      end

    end

  end

end
