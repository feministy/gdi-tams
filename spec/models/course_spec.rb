require 'spec_helper'

describe Course do
  context 'before_validation#format_pretty_dates' do
    before do
      @course = build(:course)
    end

    it 'passes validations' do
      expect(@course.save!).to be_true
    end

    it 'formats pretty_date' do
      @course.save!
      pretty_date = @course.date.strftime("%B %e, %Y (%A)")
      expect(pretty_date).to eq(@course.pretty_date)
    end

    it 'formats pretty_time' do
      @course.save!
      pretty_time = "#{@course.start_time.strftime("%I:%M %p")}–#{@course.end_time.strftime("%I:%M %p")}"
      expect(pretty_time).to eq(@course.pretty_time)
    end
  end

  context 'relationships' do
    it 'belongs_to series' do
      @series = create(:series_with_courses)
      expect(@series.courses.first.series).to eq(@series)
    end

    describe 'hours with dependent destroy' do
      before do
        @course = create(:course_with_hours)
      end

       it 'has_many' do
        expect(@course.hours.length).to eq(5)
       end

       it 'destroys hours' do
        hour = @course.hours.first
        @course.destroy
        expect { hour.reload }.to raise_error(ActiveRecord::RecordNotFound)
       end
    end

    it 'has_many teaching_assistants' do
      @course = create(:course_with_hours)
      expect(@course.teaching_assistants.count).to eq(5)
    end
  end

  context 'class methods' do
    describe 'time' do
      before do
        create_list(:course_past, 10)
        create_list(:course, 10)
      end

      it '#upcoming' do
        expect(Course.upcoming.length).to eq(10)
      end

      # BRITTLE
      # it '#last_month' do
      #   create(:course_beyond_last_month)
      #   expect(Course.last_month.length).to eq(10)
      # end
    end

    describe 'course type' do
      before do
        create_list(:course, 10)
        create_list(:series_with_courses, 1)
      end

      it '#single_day' do
        expect(Course.single_day.length).to eq(10)
      end

      it '#series' do
        expect(Course.series.length).to eq(4)
      end
    end
  end

  context 'methods' do
    describe 'simple' do
      before do
        series = create(:series_with_courses)
        @course = series.courses.first
      end

      it '#is_series?' do
        expect(@course.is_series?).to be_true
      end

      it '#need_tas?' do
        expect(@course.need_tas?).to be_true
      end

      it '#num_tas_still_needed' do
        expect(@course.num_tas_still_needed).to eq(4)
      end

      it '#tas' do
        expect(@course.tas).to eq(@course.teaching_assistants)
      end

      it '#pretty_date_short' do
        expect(@course.pretty_date_short).to be_instance_of(String)
      end
    end

    describe '#hour_for(teaching_assistant)' do
      before do
        @course = create(:course_with_hours)
        @ta = @course.teaching_assistants.first
      end

      it 'returns instance of hour' do
        expect(@course.hour_for(@ta)).to be_instance_of(Hour)
      end

      it 'requires one argument' do
        expect { @course.hour_for }.to raise_error(ArgumentError)
      end

      it 'expects one argument' do
        expect { @course.hour_for(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end
end