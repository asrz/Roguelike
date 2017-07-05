/*
 * Copyright (c) 2012, dooApp <contact@dooapp.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of dooApp nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package model.helper;

import javafx.beans.Observable;
import javafx.beans.binding.ObjectBinding;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;

/**
 * This Class provides most of the functionality needed to implement a Binding of an {@link Object} with complex
 * dependencies.
 * <br>
 * To provide a concrete implementation of this class, the method {@link javafx.beans.binding
 * .ObjectBinding#computeValue()}
 * has to be implemented to calculate the value of this binding based on the current state of the dependencies. It is
 * called when {@link javafx.beans.binding.ObjectBinding#get()} is called for an invalid binding.
 * <br>You also need to implement the {@link FXObjectBinding#configure()} method. This method will be called every
 * time the binding is becoming invalid. You will add an remove dependencies by calling {@link
 * FXObjectBinding#addObservable(javafx.beans.Observable...)}   <br><br><br>
 * You can get and example at {@link FXBooleanBinding}    <br><br>
 *
 * @author <a href="mailto:christophe@dooapp.com">Christophe DUFOUR</a>
 */
public abstract class FXObjectBinding<T> extends ObjectBinding<T> {
    /**
     * The dependencies list
     */
    private ObservableList<Observable> dependencies;
    /**
     * A nested binding
     */
    private ObjectBinding<T> nested;

    /**
     * Create an FXObjectBinding
     */
    public FXObjectBinding() {
        configure();
    }

    /**
     * Call this method instead of {@link javafx.beans.binding.ObjectBinding#bind(javafx.beans.Observable...)} it will
     * automatically call
     * {@link javafx.beans.binding.ObjectBinding#unbind(javafx.beans.Observable...)} when necessary.
     *
     * @param observables the {@link javafx.beans.Observable} dependencies
     */
    protected final void addObservable(Observable... observables) {
        getDependencies().addAll(observables);
    }

    /**
     * This method is called every time the binding is becoming invalid.<br>
     * Make sure you don't throw Exception, call {@link #addObservable(javafx.beans.Observable...)} to register
     * your dependencies.
     *
     * @see #addObservable(javafx.beans.Observable...)
     */
    protected abstract void configure();

    /**
     * {@inheritDoc}
     */
    @Override
    public void dispose() {
        getDependencies().clear();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public ObservableList<Observable> getDependencies() {
        if (dependencies == null) {
            dependencies = FXCollections.observableArrayList();
            dependencies.addListener(new ListChangeListener<Observable>() {
                @Override
                public void onChanged(Change<? extends Observable> change) {
                    nested = new ObjectBinding<T>() {
                        {
                            super.bind(dependencies.toArray(new Observable[dependencies.size()]));

                        }

                        @Override
                        protected void onInvalidating() {
                            FXObjectBinding.this.invalidate();
                        }

                        @Override
                        protected T computeValue() {
                            return compute();
                        }
                    };
                }
            });
        }
        return dependencies;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    protected void onInvalidating() {
        reconfigure();
    }

    /**
     * Make dependencies ok
     */
    private void reconfigure() {
        getDependencies().clear();
        configure();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    protected final T computeValue() {
        reconfigure();
        return nested.get();
    }

    /**
     * The new {@link #computeValue()} method
     *
     * @return {@link #computeValue()}
     */
    protected abstract T compute();
}