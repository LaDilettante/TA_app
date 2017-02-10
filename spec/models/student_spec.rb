require 'spec_helper'

describe Student do
  before { @student = Student.new(name: "Andy", email: "andrewoballard@gmail.com") }
  subject { @student }

  it { should respond_to :name }
  it { should respond_to :email }
end
